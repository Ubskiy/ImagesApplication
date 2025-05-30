//
//  FileCacheManager.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

final class FileCacheManager {
    static let shared = FileCacheManager()
    
    private let fileName = "images.txt"
    private var localFileURL: URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesDirectory.appendingPathComponent(fileName)
    }
    private let imagesDirectory = "CachedImages"
    private var imagesCacheDirectory: URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let directory = cachesDirectory.appendingPathComponent(imagesDirectory)
        
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }
    
    // MARK: - Методы для текстового файла
    
    func loadCachedFile() -> URL? {
        return FileManager.default.fileExists(atPath: localFileURL.path) ? localFileURL : nil
    }
    
    func downloadFileIfNeeded(from remoteURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        if FileManager.default.fileExists(atPath: localFileURL.path) {
            completion(.success(localFileURL))
            return
        }
        
        URLSession.shared.downloadTask(with: remoteURL) { tempURL, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL else {
                completion(.failure(NSError(domain: "DownloadFailed", code: -1)))
                return
            }
            
            do {
                try FileManager.default.moveItem(at: tempURL, to: self.localFileURL)
                completion(.success(self.localFileURL))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Методы для изображений
    
    private func imagePath(for url: URL) -> URL {
        let filename = "image_\(url.absoluteString.hashValue).jpg"
        return imagesCacheDirectory.appendingPathComponent(filename)
    }
    
    func loadCachedImage(for url: URL) -> UIImage? {
        let path = imagePath(for: url)
        guard FileManager.default.fileExists(atPath: path.path) else { return nil }
        return UIImage(contentsOfFile: path.path)
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        let fileURL = imagePath(for: url)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
    }
    
    func clearImageCache() {
        try? FileManager.default.removeItem(at: imagesCacheDirectory)
    }
}
