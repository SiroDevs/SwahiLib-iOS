//
//  CustomTabTitles.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct CustomTabTitles: View {
    let selectedTab: HomeTab
    let onSelect: (HomeTab) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(homeTabs) { tab in
                    TabItem(
                        text: tab.title,
                        isSelected: tab == selectedTab,
                        onClick: { onSelect(tab)  }
                    )
                }
            }
        }
        .frame(height: 35)
    }
}

struct TabItem: View {
    let text: String
    let isSelected: Bool
    let onClick: () -> Void

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(isSelected ? .white : .primary2)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? .primary2 : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.primary1, lineWidth: isSelected ? 0 : 1)
            )
            .onTapGesture {
                onClick()
            }
    }
}

#Preview {
    TabItem(
        text: "Methali",
        isSelected: true,
        onClick: {},
    )
}
