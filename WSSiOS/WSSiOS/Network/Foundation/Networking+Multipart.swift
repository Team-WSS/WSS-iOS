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
    static let maxImageSize: Int = 5 * 1024 * 1024 // 5MB
    
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
                           fileName: String = "image.jpg",
                           mimeType: String = "image/jpeg") -> Data {
        
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
    
    // 이미지 사이즈 압축 함수
    func compressImages(_ images: [UIImage],
                        maxImageSize: Int = MultipartConstants.maxImageSize) -> [Data] {
        var compressedDatas: [Data] = []
        
        for (index, image) in images.enumerated() {
            var quality: CGFloat = 0.5
            var data = image.jpegData(compressionQuality: quality)
            print("🖼️ 이미지 \(index) 초기 크기: \(formatBytesToMB(data?.count ?? 0))")
            
            while let compressedData = data, compressedData.count > maxImageSize, quality > 0.1 {
                quality -= 0.1
                data = image.jpegData(compressionQuality: quality)
                print("↘️ 이미지 \(index) 압축률 \(String(format: "%.1f", quality)) → 크기: \(formatBytesToMB(data?.count ?? 0))")
            }
            
            if let compressedData = data {
                if compressedData.count <= maxImageSize {
                    print("✅ 이미지 \(index) 최종 크기: \(formatBytesToMB(compressedData.count)) (업로드 가능)")
                    compressedDatas.append(compressedData)
                } else {
                    print("❌ 이미지 \(index) 최종 크기: \(formatBytesToMB(compressedData.count)) (5MB 초과로 제외됨)")
                }
            } else {
                print("⚠️ 이미지 \(index) 압축 실패")
            }
        }
        
        let totalBytes = compressedDatas.reduce(0) { $0 + $1.count }
        print("📦 업로드 대상 이미지 총 용량: \(formatBytesToMB(totalBytes))")
        return compressedDatas
    }
}
