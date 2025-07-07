//
//  Networking+Multipart.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/23/25.
//

import UIKit

import UniformTypeIdentifiers

// multipart에 사용되는 값에 대한 열거형
enum MultipartConstants {
    static let jsonPartName = "feed"
    static let imageKeyName = "images"
    static let defaultFileName = "image.jpg"
    static let mimeType = "image/jpeg"
    static let maxImageSize: Int = 512 * 512 // 0.25MB
    
    static func makeBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    static func contentTypeHeader(boundary: String) -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    static func headers(boundary: String) -> [String: String] {
        return ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Authorization": APIConstants.accessTokenHeader["Authorization"] ?? ""]
    }
}

extension Networking {
    func makeMultipartBody(keyName: String,
                           images: [Data],
                           boundary: String,
                           fileName: String = MultipartConstants.defaultFileName,
                           mimeType: String = MultipartConstants.mimeType) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        for (index, image) in images.enumerated() {
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(keyName)\"; filename=\"\(index)_\(fileName)\"\(lineBreak)")
            body.append("Content-Type: \(mimeType)\(lineBreak + lineBreak)")
            body.append(image)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    func makeMultipartBodyWithJSONAndImages(jsonPartName: String,
                                            jsonData: Data,
                                            imageKeyName: String,
                                            images: [Data],
                                            boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        // JSON
        body.append("--\(boundary)\(lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(jsonPartName)\"\(lineBreak)")
        body.append("Content-Type: application/json\(lineBreak + lineBreak)")
        body.append(jsonData)
        body.append(lineBreak)
        
        // 이미지
        let imageBody = makeMultipartBody(keyName: imageKeyName, images: images, boundary: boundary)
        body.append(imageBody)
        
        return body
    }
    
    // bytes -> MB
    private func formatBytesToMB(_ bytes: Int) -> String {
        return String(format: "%.2fMB", Double(bytes) / (1024.0 * 1024.0))
    }
    
    // 병렬 처리
    func compressImages(_ images: [UIImage],
                        maxImageSize: Int = MultipartConstants.maxImageSize) -> [Data] {
        var compressedDatas = Array<Data?>(repeating: nil, count: images.count)
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "image.compress.queue", attributes: .concurrent)
        
        for (index, image) in images.enumerated() {
            group.enter()
            queue.async {
                let compressedData = compressImage(image, index: index, maxImageSize: maxImageSize)
                compressedDatas[index] = compressedData
                group.leave()
            }
        }
        
        group.wait()
        
        return compressedDatas.map { $0 ?? Data() }
    }
    
    private func compressImage(_ image: UIImage, index: Int, maxImageSize: Int) -> Data {
        var quality: CGFloat = 1.0
        var scale: CGFloat = 0.7
        
        if let cgImageSource = CGImageSourceCreateWithData(image.pngData()! as CFData, nil),
           let utiString = CGImageSourceGetType(cgImageSource) as String?,
           let utType = UTType(utiString),
           utType.conforms(to: .heic) {
            scale = 0.5
            print("🧾 이미지 \(index) HEIC 포맷으로 감지 → 초기 해상도 0.5 적용")
        }
        
        var data: Data? = image.resizedImage(to: scale)?.jpegData(compressionQuality: quality)
        print("🖼️ 이미지 \(index) 초기 해상도 \(String(format: "%.2f", scale)) 적용 → 크기: \(formatBytesToMB(data?.count ?? 0))")
        
        while (data == nil || data!.count > maxImageSize) && quality > 0.01 && scale > 0.1 {
            if quality > 0.2 {
                quality -= 0.1
            } else {
                scale -= 0.1
                if let resizedImage = image.resizedImage(to: scale) {
                    data = resizedImage.jpegData(compressionQuality: quality)
                }
                continue
            }
            data = image.resizedImage(to: scale)?.jpegData(compressionQuality: quality)
            print("↘️ 해상도: \(String(format: "%.2f", scale)), 품질: \(String(format: "%.2f", quality)) → 크기: \(formatBytesToMB(data?.count ?? 0))")
        }
        
        if let data = data, data.count <= maxImageSize {
            print("✅ 이미지 \(index) 최종 해상도 \(String(format: "%.2f", scale)), 품질 \(String(format: "%.2f", quality)) → 크기: \(formatBytesToMB(data.count))")
            return data
        } else {
            print("❌ 이미지 \(index) 압축 실패 또는 제한 초과, 빈 데이터 추가")
            return Data()
        }
    }
}
