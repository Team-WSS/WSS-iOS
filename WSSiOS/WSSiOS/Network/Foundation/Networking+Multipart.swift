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
            return originalData
        }
        
        var bestData: Data? = nil
        var bestSize: Int = Int.max
        
        // 원본이 1MB 이하 → quality만 낮춤
        if originalSize <= oneMB {
            while quality >= 0.01 {
                if let compressed = image.jpegData(compressionQuality: quality) {
                    let size = compressed.count
                    if size <= maxImageSize {
                        print("이미지 \(index) 최종 크기: \(formatBytesToMB(size))")
                        return compressed
                    }
                    if size < bestSize {
                        bestData = compressed
                        bestSize = size
                    }
                }
                quality -= 0.05
            }
        } else {
            while scale >= 0.1 {
                if let resized = image.resizedImage(to: scale) {
                    var tempQuality: CGFloat = 1.0
                    // quality만 줄여서 시도
                    while tempQuality >= 0.01 {
                        if let compressed = resized.jpegData(compressionQuality: tempQuality) {
                            let size = compressed.count
                            if size <= maxImageSize {
                                print("이미지 \(index) 최종 크기: \(formatBytesToMB(size))")
                                return compressed
                            }
                            if size < bestSize {
                                bestData = compressed
                                bestSize = size
                            }
                        }
                        tempQuality -= 0.05
                    }
                }
                scale -= 0.1
            }
        }
        
        if let bestData = bestData {
            print("⚠️ 이미지 \(index) 최선 압축 결과 반환 → 크기: \(formatBytesToMB(bestData.count))")
            return bestData
        } else {
            print("이미지 \(index) 압축 실패, 빈 데이터 반환")
            return Data()
        }
    }
}
