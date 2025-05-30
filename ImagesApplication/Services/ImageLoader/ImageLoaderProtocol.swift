//
//  ImageLoaderProtocol.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit
protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void)
}
