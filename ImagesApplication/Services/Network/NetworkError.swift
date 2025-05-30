//
//  NetworkError.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import Foundation

enum NetworkError: Error {
    case invalidData
    case invalidImageData
    case invalidResponse(statusCode: Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse(let code):
            return "Server returned status code \(code)"
        case .invalidImageData:
            return "Invalid image data"
        case .invalidData:
            return "Invalid data"
        }
    }
}
