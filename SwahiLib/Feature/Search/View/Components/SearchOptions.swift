//
//  SearchOptions.swift
//  SwahiLib
//
//  Created by @sirodevs on 01/12/2025.
//

import SwiftUI

enum SearchOptionsParts: String, CaseIterable {
    case byTitle = "Ya Kawaida"
    case byMeaning = "Ya Maana"
    
    var description: String {
        return self.rawValue
    }
}

enum SearchOptionsPatterns: String, CaseIterable {
    case beginning = "Mwanzo"
    case middle = "Katikati"
    case end = "Mwisho"
    
    var description: String {
        return self.rawValue
    }
}

struct SearchOptions: View {
    @Binding var selectedPart: SearchOptionsParts
    @Binding var selectedPattern: SearchOptionsPatterns
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                HStack(spacing: 4) {
                    Text("Sehemu")
                        .font(.system(size: 16))
                    
                    Picker("", selection: $selectedPart) {
                        ForEach(SearchOptionsParts.allCases, id: \.self) { part in
                            Text(part.description)
                                .font(.system(size: 16))
                                .tag(part)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                }
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Mwelekeo")
                        .font(.system(size: 16))
                    
                    Picker("", selection: $selectedPattern) {
                        ForEach(SearchOptionsPatterns.allCases, id: \.self) { pattern in
                            Text(pattern.description)
                                .font(.system(size: 16))
                                .tag(pattern)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                }
            }
        }
    }
}
