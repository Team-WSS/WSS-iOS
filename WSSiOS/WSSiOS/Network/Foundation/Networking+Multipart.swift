//
//  Networking+Multipart.swift
//  WSSiOS
//
//  Created by Seoyeon Choi on 5/23/25.
//

import UIKit

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
    
    // 병렬 + 비동기 이미지 압축
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
        let oneMB = 1024 * 1024
        var quality: CGFloat = 1.0
        var scale: CGFloat = 0.9
        
        guard let originalData = image.jpegData(compressionQuality: 1.0) else {
            return Data()
        }
        
        let originalSize = originalData.count
        print("이미지 \(index) 원본 사이즈: \(formatBytesToMB(originalSize))")
        
        // 원본이 이미 작으면 압축 생략
        if originalSize <= maxImageSize {
            print("이미지 \(index) 압축 생략")
            return originalData
        }
        
        var data: Data?
        
        // 원본이 1MB 이하 → quality만 낮춤
        if originalSize <= oneMB {
            while let compressed =
                    image.jpegData(compressionQuality: quality),
                  compressed.count > maxImageSize,
                  quality > 0.1 {
                data = compressed
                
                print("이미지 \(index) 크기: \(formatBytesToMB(data?.count ?? 0))")
                quality -= 0.1
            }
        } else {
            // 원본이 1MB 초과 → scale 먼저 줄이고 필요 시 quality도 함께 감소
            data = image.resizedImage(to: scale)?.jpegData(compressionQuality: quality)
            print("이미지 \(index)크기: \(formatBytesToMB(data?.count ?? 0))")
            
            while (data == nil || data!.count > maxImageSize) && quality > 0.01 && scale > 0.1 {
                if quality > 0.2 {
                    quality -= 0.1
                } else {
                    scale -= 0.1
                    if let resized = image.resizedImage(to: scale) {
                        data = resized.jpegData(compressionQuality: quality)
                    }
                    continue
                }
                data = image.resizedImage(to: scale)?.jpegData(compressionQuality: quality)
                print("↘️ 해상도: \(String(format: "%.2f", scale)), 품질: \(String(format: "%.2f", quality)) → 크기: \(formatBytesToMB(data?.count ?? 0))")
            }
        }
        
        if let data = data, data.count <= maxImageSize {
            print("이미지 \(index) 최종 크기: \(formatBytesToMB(data.count))")
            return data
        } else {
            print("❌ 이미지 \(index) 압축 실패 또는 제한 초과, 빈 데이터 추가")
            return Data()
        }
    }
}
