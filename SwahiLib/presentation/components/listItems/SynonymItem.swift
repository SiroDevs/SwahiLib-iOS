//
//  SynonymItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//

import SwiftUI

struct SynonymItem: View {
    var title: String
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(alignment: .center) {
                Image(systemName: "arrow.right.circle")
                    .foregroundColor(Color(.onPrimaryContainer))

                Spacer().frame(width: 12)

                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(Color(.onPrimaryContainer))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "arrow.forward")
                    .foregroundColor(Color(.onPrimaryContainer))
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(.background1)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
    }
}

#Preview {
    SynonymItem(
        title: "Hata Kidogo",
        onClick: {}
    )
    .padding()
}
