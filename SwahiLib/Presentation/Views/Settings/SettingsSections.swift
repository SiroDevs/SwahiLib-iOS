//
//  SettingsSections.swift
//  SwahiLib
//
//  Created by Siro Daves on 26/08/2025.
//

import SwiftUI

struct ThemeSectionView: View {
    @Binding var selectedTheme: AppThemeMode
    
    var body: some View {
        Section(header: Text("Mandhari")) {
            Picker("Chagua Mandhari", selection: $selectedTheme) {
                ForEach(AppThemeMode.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

struct ProSectionView: View {
    let onTap: () -> Void
    
    var body: some View {
        Section(header: Text("SwahiLib Pro")) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Jiunge na SwahiLib Pro")
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
}

struct ReviewSectionView: View {
    let onReview: () -> Void
    let onEmail: () -> Void

    var body: some View {
        Section(header: Text("MAONI")) {
            Button(action: onReview) {
                HStack(spacing: 12) {
                    Image(systemName: "text.badge.star")
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tupe review")
                            .font(.headline)
                        Text("Unaweza kutupa review ili kitumizi hizi kionekane kwa wengine")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            Button(action: onEmail) {
                HStack(spacing: 12) {
                    Image(systemName: "envelope")
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Wasiliana nasi")
                            .font(.headline)
                        Text("Iwapo una malalamishi/maoni, tutumie barua pepe. Usikose kuweka picha za skrini (screenshot) nyingi uwezavyo.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct ResetSectionView: View {
    let onTap: () -> Void
    
    var body: some View {
        Section(header: Text("HATARI").foregroundColor(.red)) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Weka upya data")
                            .font(.headline).foregroundColor(.red)
                        Text("Unaweza kufuta data yote iliyoko na uanze kudondoa upya")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}
