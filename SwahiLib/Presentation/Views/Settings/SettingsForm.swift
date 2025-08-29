//
//  SettingsForm.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import SwiftUI

struct SettingsForm: View {
    @ObservedObject var viewModel: MainViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showPaywall: Bool
    @Binding var showResetAlert: Bool
    
    var body: some View {
        Form {
            SettingsSection(header: "Mandhari") {
                Picker("Chagua Mandhari", selection: $themeManager.selectedTheme) {
                    ForEach(AppThemeMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
            }

            #if !DEBUG
            if !viewModel.activeSubscriber {
                SettingsSection(header: "Swahilib Pro") {
                    SettingsRow(
                        systemImage: "star.fill",
                        title: L10n.joinPro,
                        subtitle: L10n.joinProDesc,
                        foregroundColor: .yellow,
                        action: { showPaywall = true }
                    )
                }
            }
            #endif

            SettingsSection(header: "Maoni") {
                SettingsRow(
                    systemImage: "text.badge.star",
                    title: L10n.leaveReview,
                    subtitle: L10n.leaveReviewDesc,
                    action: viewModel.promptReview
                )
                SettingsRow(
                    systemImage: "envelope",
                    title: L10n.contactUs,
                    subtitle: L10n.contactUsDesc,
                    action: AppUtilities.sendEmail
                )
            }

            SettingsSection(header: "Danger") {
                SettingsRow(
                    systemImage: "exclamationmark.triangle.fill",
                    title: L10n.resetData,
                    subtitle: L10n.resetDataDesc,
                    foregroundColor: .red,
                    action: { showResetAlert = true }
                )
            }
        }
    }
}
