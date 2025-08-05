//
//  SettingsView.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/08/2025.
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

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Section(header: Text("Mandhari")) {
                Picker("Chagua Mandhari", selection: Binding(
                    get: { themeManager.selectedTheme },
                    set: { themeManager.selectedTheme = $0 }
                )) {
                    ForEach(AppThemeMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .navigationTitle("Mipangilio")
    }
}
#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
