//
//  SceneDelegate.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 29.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        ThemeManager.shared.apply(theme: ThemeManager.shared.currentTheme)
        
        let window = UIWindow(windowScene: windowScene)
        let viewModel = GalleryViewModel()
        let viewController = GalleryViewController(viewModel: viewModel)
        window.rootViewController = UINavigationController(rootViewController: viewController)
        self.window = window
        window.makeKeyAndVisible()
    }
}
