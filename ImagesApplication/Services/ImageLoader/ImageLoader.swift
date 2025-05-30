//
//  ImageLoader.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit

final class ImageLoader: ImageLoaderProtocol {
    private let networkService: NetworkServiceProtocol
    private let cache = NSCache<NSURL, UIImage>()
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        // 1. Проверка в памяти
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(.success(cachedImage))
            return
        }

        // 2. Проверка на диске
        if let diskImage = loadImageFromDisk(for: url) {
            cache.setObject(diskImage, forKey: url as NSURL)
            completion(.success(diskImage))
            return
        }

        // 3. Загрузка из сети
        networkService.downloadImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                let resizedImage = image.resized(to: CGSize(width: 200, height: 200))
                if let resizedImage = resizedImage {
                    self?.cache.setObject(resizedImage, forKey: url as NSURL)
                    self?.saveImageToDisk(resizedImage, for: url)
                }
                completion(.success(resizedImage))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func cacheDirectoryURL() -> URL {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return caches.appendingPathComponent("ImageCache", isDirectory: true)
    }

    private func localImageURL(for url: URL) -> URL {
        let fileName = "\(url.absoluteString.hashValue).png"
        return cacheDirectoryURL().appendingPathComponent(fileName)
    }


    private func saveImageToDisk(_ image: UIImage, for url: URL) {
        let directory = cacheDirectoryURL()
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }

        let fileURL = localImageURL(for: url)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }

    private func loadImageFromDisk(for url: URL) -> UIImage? {
        let fileURL = localImageURL(for: url)
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }

}
