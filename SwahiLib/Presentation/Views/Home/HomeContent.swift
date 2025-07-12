//
//  HomeContent.swift
//  SwahiLib
//
//  Created by Siro Daves on 05/07/2025.
//

import SwiftUI

struct HomeContent: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            List { }
            .toolbar {
                ToolbarItem {
                    Button(action: {}) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
