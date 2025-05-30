//
//  ThemeManager.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

final class ThemeManager {
    static let shared = ThemeManager()
    private let themeKey = "SelectedTheme"

    var currentTheme: AppTheme {
        get {
            let rawValue = UserDefaults.standard.string(forKey: themeKey) ?? AppTheme.light.rawValue
            return AppTheme(rawValue: rawValue) ?? .light
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: themeKey)
            apply(theme: newValue)
        }
    }

    func apply(theme: AppTheme) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { window in
                window.overrideUserInterfaceStyle = theme.interfaceStyle
            }
    }

    func toggleTheme() {
        currentTheme = currentTheme.toggled
    }
}

