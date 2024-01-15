//
//  Networking.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

protocol Networking {
    func makeHTTPRequest(
        method: HTTPMethod,
        baseURL: String,
        path: String,
        headers: [String: String]?,
        body: Data?) throws -> URLRequest
    
    func makeMultipartFormImageBody(keyName: String,
                                    images: [Data],
                                    fileName: String,
                                    mimeType: String) -> Data
    
    func validataDataResponse<T: Decodable> (_ data: Data, response: URLResponse, to target: T.Type) throws -> T
}

extension Networking {
    
    func makeHTTPRequest(
        method: HTTPMethod,
        baseURL: String = Bundle.main.object(forInfoDictionaryKey: Config.Keys.Plist.baseURL) as? String ?? "",
        path: String,
        headers: [String: String]?,
        body: Data?) throws -> URLRequest
    {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkServiceError.invalidURLError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach({ header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        })
        if let body = body {
            request.httpBody = body
        }
        
        print(baseURL)
        return request
    }
    
    func makeMultipartFormImageBody(keyName: String,
                                    images: [Data],
                                    fileName: String = "image.jpg",
                                    mimeType: String = "image/jpeg") -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        for image in images {
            //            body.append("--\(APIConstants.boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(keyName)\"; filename=\"\(fileName)\"\(lineBreak)")
            body.append("Content-Type: \(mimeType)\(lineBreak + lineBreak)")
            body.append(image)
            body.append(lineBreak)
        }
        
        //        body.append("--\(APIConstants.boundary)--\(lineBreak)") // End multipart form and return
        return body
    }
    
    func validataDataResponse<T: Decodable> (_ data: Data, response: URLResponse, to target: T.Type) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkServiceError.unknownError
        }
        
        guard response.statusCode == 200 else {
            throw NetworkServiceError.init(rawValue: response.statusCode) ?? .unknownError
        }
        
        let result = try decode(data: data, to: T.self)
        
        return result
    }
    
    func decode<T: Decodable>(data: Data, to target: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(target, from: data)
        } catch {
            throw NetworkServiceError.responseDecodingError
        }
    }
}
