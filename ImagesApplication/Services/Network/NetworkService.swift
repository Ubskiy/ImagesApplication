//
//  NetworkService.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit

final class NetworkService: NetworkServiceProtocol {
    
    
    func downloadTextFile(from url: URL, completion: @escaping (Result<[String], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let text = String(data: data, encoding: .utf8) else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            let lines = text.components(separatedBy: .newlines)
            completion(.success(lines))
        }.resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Response for \(url.absoluteString): \(httpResponse.statusCode)")
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP error for \(url): \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.invalidResponse(statusCode: httpResponse.statusCode)))
                    return
                }
            }

            
            if let error = error {
                print("Error loading \(url.absoluteString): \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received for \(url.absoluteString)")
                completion(.failure(NetworkError.invalidImageData))
                return
            }
            
            guard let image = UIImage(data: data), image.size.width > 0, image.size.height > 0 else {
                print("Invalid image or not an actual image at \(url.absoluteString)")
                completion(.failure(NetworkError.invalidImageData))
                return
            }

            
            completion(.success(image))
        }.resume()
    }
}

