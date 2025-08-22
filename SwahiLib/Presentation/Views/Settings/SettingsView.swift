//
//  SettingsView.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/08/2025.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

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
    @State private var showPaywall: Bool = false

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

            Section {
                Button(action: {
                    showPaywall = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("SwahiLib Pro")
                                .font(.headline)
                            Text("Jiunge na SwahiLib Pro, ufurahie utafutaji wa kina, vipengele kadhaa kama vipendwa na alamisho kama njia ya kumuunga mkono developer wa SwahiLib")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .navigationTitle("Mipangilio")
    }
}


#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
