//
//  IdiomsList.swift
//  SwahiLib
//
//  Created by Siro Daves on 11/07/2025.
//

import SwiftUI

struct IdiomsList: View {
    let idioms: [Idiom]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(idioms.enumerated()), id: \.element.id) { index, idiom in
//                    NavigationLink {
////                        PresenterView(song: idiom)
//                    } label: {
//                        IdiomItem(
//                            idiom: idiom,
//                        )
//                    }
                    IdiomItem(
                        idiom: idiom,
                    )
                }
            }
        }
    }
}
