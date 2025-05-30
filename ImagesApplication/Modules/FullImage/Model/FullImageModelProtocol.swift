//
//  FullImageModelProtocol.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

protocol FullImageModelProtocol {
    func loadOriginalImage(completion: @escaping (Result<UIImage, Error>) -> Void)
    func saveImageToCache(_ image: UIImage)
}
