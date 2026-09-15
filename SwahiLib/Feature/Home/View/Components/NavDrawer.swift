//
//  NavDrawer.swift
//  SwahiLib
//
//  A custom slide-in drawer (SwiftUI has no built-in equivalent to
//  Android's ModalNavigationDrawer). Mirrors the core of
//  feature/home/view/components/HomeNavDrawer.kt: header with app icon +
//  title + tagline, then menu items. Scoped down to what was asked for —
//  Neno la Siku, Methali ya Siku, Mipangilio ya SwahiLib — the rest of
//  Android's items (Jamii ya SwahiLib, Maendeleo Yangu, Jinsi ya Kutumia,
//  Usaidizi na Maoni, Donate) are intentionally left out for now.
//

import SwiftUI

struct NavDrawerItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let destination: DrawerDestination
}

private let navDrawerItems: [NavDrawerItem] = [
    NavDrawerItem(icon: "book.pages", label: "Neno la Siku", destination: .dailyWord),
    NavDrawerItem(icon: "quote.opening", label: "Methali ya Siku", destination: .dailyProverb),
]

struct NavDrawer: View {
    @Binding var isOpen: Bool
    var onSelect: (DrawerDestination) -> Void

    private let drawerWidth: CGFloat = 300

    var body: some View {
        ZStack(alignment: .leading) {
            if isOpen {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isOpen = false
                        }
                    }
                    .transition(.opacity)
            }

            if isOpen {
                drawerContent
                    .frame(width: drawerWidth)
                    .frame(maxHeight: .infinity)
                    .background(.regularMaterial)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isOpen)
    }

    private var drawerContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(.mainIcon)
                    .resizable()
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 2) {
                    Text(AppConstants.appTitle)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary1)
                    Text(AppConstants.appTagline)
                        .font(.system(size: 13))
                        .foregroundColor(.onSurface.opacity(0.6))
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider()

            VStack(alignment: .leading, spacing: 0) {
                ForEach(navDrawerItems) { item in
                    drawerRow(icon: item.icon, label: item.label) {
                        select(item.destination)
                    }
                }
            }
            .padding(.top, 8)

            Spacer()

            Divider()

            drawerRow(icon: "gear", label: "Mipangilio ya SwahiLib") {
                select(.settings)
            }
            .padding(.bottom, 8)
        }
        .safeAreaPadding(.top)
    }

    private func drawerRow(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.onSurface.opacity(0.7))
                    .frame(width: 24)

                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.onSurface)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }

    private func select(_ destination: DrawerDestination) {
        withAnimation(.easeInOut(duration: 0.25)) {
            isOpen = false
        }
        onSelect(destination)
    }
}
