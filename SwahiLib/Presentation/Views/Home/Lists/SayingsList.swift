//
//  SayingsList.swift
//  SwahiLib
//
//  Created by Siro Daves on 11/07/2025.
//

import SwiftUI

struct SayingsList: View {
    let sayings: [Saying]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(sayings.enumerated()), id: \.element.id) { index, saying in
//                    NavigationLink {
////                        PresenterView(song: saying)
//                    } label: {
//                        SayingItem(
//                            saying: saying,
//                        )
//                    }
                    SayingItem(
                        saying: saying,
                    )
                }
            }
        }
    }
}
