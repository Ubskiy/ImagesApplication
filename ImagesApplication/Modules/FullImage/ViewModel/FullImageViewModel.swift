//
//  FullImageViewModel.swift.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

final class FullImageViewModel: FullImageViewModelProtocol {
    private let imageURL: URL
    private let model: FullImageModelProtocol
    
    var image: UIImage?
    var isLoading: Bool = false
    var onImageLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(imageURL: URL, model: FullImageModelProtocol) {
        self.imageURL = imageURL
        self.model = model
    }
    
    func loadImage() {
        isLoading = true
        
        model.loadOriginalImage { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let image):
                    self?.image = image
                    self?.onImageLoaded?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func saveToCache() {
        guard let image = image else { return }
        model.saveImageToCache(image)
    }
}
