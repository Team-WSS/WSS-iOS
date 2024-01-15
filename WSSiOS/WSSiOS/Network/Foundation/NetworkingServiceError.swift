//
//  NetworkingServiceError.swift
//  WSSiOS
//
//  Created by 최서연 on 1/14/24.
//

import Foundation

public enum NetworkServiceError: Int, Error, CustomStringConvertible {
    public var description: String { self.errorDescription }
    
    case emptyDataError
    case responseDecodingError
    case payloadEncodingError
    case unknownError
    case invalidURLError
    case invalidRequestError = 400
    case authenticationError = 401
    case forbiddenError = 403
    case notFoundError = 404
    case notAllowedHTTPMethodError = 405
    case timeoutError = 408
    case internalServerError = 500
    case notSupportedError = 501
    case badGatewayError = 502
    case invalidServiceError = 503
    
    var errorDescription: String {
        switch self {
        case .invalidURLError: return "INVALID_URL_ERROR"
        case .invalidRequestError: return "400:INVALID_REQUEST_ERROR"
        case .authenticationError: return "401:AUTHENTICATION_FAILURE_ERROR"
        case .forbiddenError: return "403:FORBIDDEN_ERROR"
        case .notFoundError: return "404:NOT_FOUND_ERROR"
        case .notAllowedHTTPMethodError: return "405:NOT_ALLOWED_HTTP_METHOD_ERROR"
        case .timeoutError: return "408:TIMEOUT_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .notSupportedError: return "501:NOT_SUPPORTED_ERROR"
        case .badGatewayError: return "502:BAD_GATEWAY_ERROR"
        case .invalidServiceError: return "503:INVALID_SERVICE_ERROR"
        case .responseDecodingError: return "RESPONSE_DECODING_ERROR"
        case .payloadEncodingError: return "REQUEST_BODY_ENCODING_ERROR"
        case .unknownError: return "UNKNOWN_ERROR"
        case .emptyDataError: return "RESPONSE_DATA_EMPTY_ERROR"
        }
    }
}
