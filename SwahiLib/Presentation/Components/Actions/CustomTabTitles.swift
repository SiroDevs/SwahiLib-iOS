//
//  CustomTabTitles.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct CustomTabTitlesView: View {
    @Binding var selectedTab: HomeTab

    var body: some View {
        VStack(spacing: 0) {
            Color(.lightGray)
                .frame(height: 1)
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Spacer().frame(width: 4)
                        ForEach(HomeTab.allCases) { tab in
                            TabItemView(
                                text: tab.title,
                                isSelected: tab == selectedTab,
                                onClick: { selectedTab = tab }
                            )
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.white)
                    .clipShape(
                        RoundedCornerShape(corners: [.bottomRight], radius: 15)
                    )
            )
        }
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
