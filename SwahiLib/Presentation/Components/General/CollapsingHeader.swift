//
//  CollapsingHeader.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/08/2025.
//

import SwiftUI

struct CollapsingHeader: View {
    var title: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color(.primary1))
                .frame(height: 100)

            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 30, weight: .bold))
                .padding(15)
        }
        .frame(maxWidth: .infinity)
    }
}
