//
//  FullImageModel.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

final class FullImageModel: FullImageModelProtocol {
    private let imageURL: URL
    private let networkService: NetworkServiceProtocol
    private let cacheManager: FileCacheManager
    
    init(
        imageURL: URL,
        networkService: NetworkServiceProtocol = NetworkService(),
        cacheManager: FileCacheManager = FileCacheManager.shared
    ) {
        self.imageURL = imageURL
        self.networkService = networkService
        self.cacheManager = cacheManager
    }
    
    func loadOriginalImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Сначала проверяем кэш
        if let cachedImage = cacheManager.loadCachedImage(for: imageURL) {
            completion(.success(cachedImage))
            return
        }
        // Если нет в кэше - загружаем
        networkService.downloadImage(from: imageURL) { [weak self, imageURL] result in
            switch result {
            case .success(let image):
                completion(.success(image))
                self?.cacheManager.saveImage(image, for: imageURL)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveImageToCache(_ image: UIImage) {
        cacheManager.saveImage(image, for: imageURL)
    }
}
