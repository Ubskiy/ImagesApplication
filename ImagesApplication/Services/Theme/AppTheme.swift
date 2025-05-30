//
//  AppTheme.swift
//  ImagesApplication
//
//  Created by Арсений Убский on 30.05.2025.
//
import UIKit

enum AppTheme: String {
    case light
    case dark

    var toggled: AppTheme {
        return self == .light ? .dark : .light
    }

    var interfaceStyle: UIUserInterfaceStyle {
        return self == .light ? .light : .dark
    }

    var buttonTitle: String {
        return self == .light ? "🌙" : "☀️"
    }
}

