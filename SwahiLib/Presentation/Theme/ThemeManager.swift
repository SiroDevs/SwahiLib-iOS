//
//  ThemeManager.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/08/2025.
//

import SwiftUI

enum AppThemeMode: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: String { rawValue }

    var displayName: String {
        switch self {
            case .light: return "Mandhari ya Nuru"
            case .dark: return "Mandhari ya Giza"
            case .system: return "Chaguo la Mfumo"
        }
    }
}


final class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = AppThemeMode.system.rawValue

    var selectedTheme: AppThemeMode {
        get { AppThemeMode(rawValue: selectedThemeRaw) ?? .system }
        set { selectedThemeRaw = newValue.rawValue }
    }
}
