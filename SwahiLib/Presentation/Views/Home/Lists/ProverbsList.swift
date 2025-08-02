//
//  ProverbsList.swift
//  SwahiLib
//
//  Created by Siro Daves on 11/07/2025.
//

import SwiftUI

struct ProverbsList: View {
    let proverbs: [Proverb]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(proverbs.enumerated()), id: \.element.id) { index, proverb in
                    NavigationLink {
                        ProverbView(proverb: proverb)
                    } label: {
                        ProverbItem(proverb: proverb)
                    }
                }
            }
        }
    }
}
