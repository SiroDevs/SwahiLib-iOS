//
//  MeaningsView.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/08/2025.
//

import SwiftUI

struct MeaningsView: View {
    let meanings: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(meanings.enumerated()), id: \.offset) { index, meaning in
                let parts = meaning.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
                let maana = parts.first ?? ""
                let mfano = parts.count > 1 ? parts[1] : nil

                CardView(maana: maana, mfano: mfano, index: index, total: meanings.count)
            }
        }
    }
}

struct CardView: View {
    let maana: String
    let mfano: String?
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(total > 1 ? "\(index + 1). " : "")\(maana)")
                .font(.system(size: 22))
                .foregroundColor(Color(.primary1))
                .padding(.leading, 5)
                .padding(.bottom, mfano != nil ? 8 : 0)

            if let mfano = mfano, !mfano.isEmpty {
                Divider()
                    .background(Color(.primary1).opacity(0.3))
                    .padding(.bottom, 8)

                HStack {
                    Text("Mfano: ")
                        .bold()
                    Text(mfano)
                        .italic()
                }
                .font(.system(size: 18))
                .foregroundColor(Color(.primary1))
                .padding(.leading, 15)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.vertical, 4)
    }
}
