//
//  FullImageViewModelProtocol.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

protocol FullImageViewModelProtocol {
    var image: UIImage? { get }
    var isLoading: Bool { get }
    var onImageLoaded: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadImage()
    func saveToCache()
}
