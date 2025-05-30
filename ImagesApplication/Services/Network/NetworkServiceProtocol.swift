//
//  NetworkServiceProtocol.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//
import UIKit

protocol NetworkServiceProtocol {
    func downloadTextFile(from url: URL, completion: @escaping (Result<[String], Error>) -> Void)
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}
