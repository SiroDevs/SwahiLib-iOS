//
//  PresenterTabs.swift
//  SwahiLib
//
//  Created by Siro Daves on 07/05/2025.
//

import SwiftUI

struct PresenterTabs: View {
    let verses: [String]
    @Binding var selected: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 5)
            
            TabView(selection: $selected) {
                ForEach(verses.indices, id: \.self) { index in
                    VerseContent(verse: verses[index])
                        .tag(index)
                        .rotationEffect(.degrees(-90))
                }
            }.rotationEffect(.degrees(90))
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
        }
        .padding()
    }
}

struct VerseContent: View {
    let verse: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(verse)
                .font(.largeTitle)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding(15)
    }
}

#Preview{
    PresenterTabs(
        verses: [
            "Fear not, little flock,\nfrom the cross to the throne,\nFrom death into life\nHe went for His own;\nAll power in earth,\nall power above,\nIs given to Him\nfor the flock of His love.",
            "CHORUS\nOnly believe, only believe,\nAll things are possible,\nOnly believe, Only believe,\nonly believe,\nAll things are possible,\nonly believe.",
            "Fear not, little flock,\nHe goeth ahead,\nYour Shepherd selecteth\nthe path you must tread;\nThe waters of Marah\nHe’ll sweeten for thee,\nHe drank all the bitter\nin Gethsemane."
        ],
        selected: .constant(0)
    )
}
