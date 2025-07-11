//
//  CustomTabTitles.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct CustomTabTitlesView: View {
    let selectedTab: HomeTab
    let onSelect: (HomeTab) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(homeTabs) { tab in
                    TabItemView(
                        text: tab.title,
                        isSelected: tab == selectedTab,
                        onClick: { onSelect(tab)  }
                    )
                }
            }
        }
        .padding(.leading, 10)
        .frame(height: 40)
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct TabItemView: View {
    let text: String
    let isSelected: Bool
    let onClick: () -> Void

    var body: some View {
        Text(text.uppercased())
            .font(.body.bold())
            .foregroundColor(isSelected ? .white : Color("Primary1"))
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color("Primary1") : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Primary1"), lineWidth: isSelected ? 0 : 1)
            )
            .onTapGesture {
                onClick()
            }
    }
}
