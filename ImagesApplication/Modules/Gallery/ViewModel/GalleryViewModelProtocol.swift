//
//  GalleryViewModelProtocol.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit

protocol GalleryViewModelProtocol {
    var imageURLs: [URL] { get }
    var onUpdate: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func loadImageLinks()
    func loadImage(for index: Int, completion: @escaping (Result<UIImage?, Error>) -> Void)
}
