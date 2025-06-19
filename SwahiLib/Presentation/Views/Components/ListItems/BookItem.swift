//
//  BookItemView.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import SwiftUI

import SwiftUI

struct BookItem: View {
    let book: Book
    let isSelected: Bool
    let onTap: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let unselectedColor = colorScheme == .light ? Color.white : .primaryDark1
        let backgroundColor = isSelected ? .primary1 : unselectedColor
        let foregroundColor = isSelected ? Color.white : Color.black

        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
                .shadow(radius: 5)
            
            HStack(spacing: 15) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 24))
                    .padding(5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(refineTitle(txt: book.title))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(foregroundColor)

                    Text("\(book.songs) \(book.subTitle) songs")
                        .font(.system(size: 18))
                        .foregroundColor(foregroundColor)
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            onTap()
        }
    }
}


#Preview {
    BookItem(
        book: Book(
            bookId: 1,
            title: "Songs of Worship",
            subTitle: "worship",
            songs: 750,
            position: 1,
            bookNo: 1,
            enabled: true,
            created: ""
        ),
        isSelected: false,
        onTap: { print("Amen") }
    )
    .padding()
}

