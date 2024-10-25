//
//  ServiceError.swift
//  WSSiOS
//
//  Created by YunhakLee on 10/6/24.
//

import Foundation

enum ServiceError: Error, CustomStringConvertible {
    case httpError(statusCode: Int, code: String?, message: String?)
    case responseDecodingError
    case requestBodyEncodingError
    case emptyDataError
    case unknownError
    
    init(statusCode: Int, errorResponse: ServerErrorResponse? = nil) {
        switch statusCode {
        case 400...499:
            self = .httpError(statusCode: statusCode, code: errorResponse?.code, message: errorResponse?.message)
        case 500...599:
            self = .httpError(statusCode: statusCode, code: nil, message: nil)
        default:
            self = .unknownError
        }
    }
    
    var description: String {
        switch self {
        case .httpError(let statusCode, let code, let message):
            switch statusCode {
            case 400:
                return "400:INVALID_REQUEST_ERROR \(code ?? ""): \(message ?? "")"
            case 401:
                return "401:AUTHENTICATION_FAILURE_ERROR \(code ?? ""): \(message ?? "")"
            case 403:
                return "403:FORBIDDEN_ERROR \(code ?? ""): \(message ?? "")"
            case 404:
                return "404:NOT_FOUND_ERROR \(code ?? ""): \(message ?? "")"
            case 405:
                return "405:NOT_ALLOWED_HTTP_METHOD_ERROR \(code ?? ""): \(message ?? "")"
            case 408:
                return "408:TIMEOUT_ERROR \(code ?? ""): \(message ?? "")"
            case 500:
                return "500:INTERNAL_SERVER_ERROR"
            case 501:
                return "501:NOT_SUPPORTED_ERROR"
            case 502:
                return "502:BAD_GATEWAY_ERROR"
            case 503:
                return "503:INVALID_SERVICE_ERROR"
            default:
                if (400...499).contains(statusCode) {
                    return "\(statusCode):CLIENT_ERROR \(code ?? ""): \(message ?? "")"
                } else if (500...599).contains(statusCode) {
                    return "\(statusCode):SERVER_ERROR"
                } else {
                    return "\(statusCode):UNKNOWN_HTTP_ERROR"
                }
            }
        case .responseDecodingError:
            return "RESPONSE_DECODING_ERROR"
        case .requestBodyEncodingError:
            return "REQUEST_BODY_ENCODING_ERROR"
        case .emptyDataError:
            return "RESPONSE_DATA_EMPTY_ERROR"
        case .unknownError:
            return "UNKNOWN_ERROR"
        }
    }
}

struct ServerErrorResponse: Codable {
    let code: String
    let message: String
}
