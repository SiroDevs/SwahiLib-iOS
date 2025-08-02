//
//  SynonymItem.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/08/2025.
//

import SwiftUI

struct SynonymItem: View {
    var title: String
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(alignment: .center) {
                Image(systemName: "arrow.circle.right")
                    .foregroundColor(Color(.primary1))

                Spacer().frame(width: 12)

                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(Color(.primary1))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "arrow.forward")
                    .foregroundColor(Color(.primary1))
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
    }
}
