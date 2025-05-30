//
//  GalleryViewModel.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit

final class GalleryViewModel: GalleryViewModelProtocol {
    var imageURLs: [URL] = []
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let fileURL = URL(string: "https://it-link.ru/test/images.txt")!
    private let imageLoader: ImageLoaderProtocol
    
    init(
        imageLoader: ImageLoaderProtocol = ImageLoader()
    ) {
        self.imageLoader = imageLoader
        NetworkMonitor.shared.onConnectionRestored = { [weak self] in
            self?.loadImageLinks()
        }
    }
    
    func loadImageLinks() {
        imageURLs = []
        let remoteURL = fileURL

        FileCacheManager.shared.downloadFileIfNeeded(from: remoteURL) { [weak self] result in
            switch result {
            case .success(let localURL):
                do {
                    let content = try String(contentsOf: localURL)
                    let lines = content.components(separatedBy: .newlines)
                    self?.processLines(lines)
                } catch {
                    self?.onError?(error)
                }
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }

    
    private func processLines(_ lines: [String]) {
        imageURLs = lines.compactMap { line in
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }
            return URL(string: trimmed)
        }
        
        DispatchQueue.main.async {
            self.onUpdate?()
        }
    }
    
    func loadImage(for index: Int, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard index >= 0 && index < imageURLs.count else {
            completion(.success(nil))
            return
        }
        
        let url = imageURLs[index]
        
        imageLoader.loadImage(from: url) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
