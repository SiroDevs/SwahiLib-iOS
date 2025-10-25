//
//  UpgradeBanner.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/10/2025.
//

import SwiftUI

struct UpgradeBanner: View {
    var onUpgrade: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                Text("You are currently limited to only 1 listing")
                    .font(.caption)
                Spacer()
                Button("Upgrade to PRO") {
                    onUpgrade()
                }
                .font(.caption)
                .buttonStyle(.borderedProminent)
            }
            .padding(5)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
}

struct UpgradeBanner1: View {
    var onUpgrade: () -> Void
    
    var body: some View {
        Button(action: onUpgrade) {
            HStack {
                Image(systemName: "crown.fill")
                    .frame(width: 24, height: 24)
                    .foregroundColor(.yellow)
                
                VStack(alignment: .leading) {
                    Text(L10n.joinPro)
                        .font(.headline).foregroundColor(.primary)
                    Text(L10n.joinProDesc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
        .background(.onSurfaceVariant)
        .contentShape(Rectangle())
    }
}
