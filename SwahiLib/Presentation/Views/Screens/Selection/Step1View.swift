//
//  Step1View.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct Step1View: View {
    @StateObject private var viewModel: SelectionViewModel = DiContainer.shared.resolve(SelectionViewModel.self)
    @State private var showNoSelectionAlert = false
    @State private var showConfirmationAlert = false
    @State private var navigateToNextScreen = false

    var body: some View {
        Group {
            navigateToNextScreen ? AnyView(Step2View()) : AnyView(mainContent)
        }
    }
    
    private var mainContent: some View {
        VStack {
            Text("Select Songbooks")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            stateContent.background(Color.white)
        }
        .background(.primary1)
        .alert(isPresented: $showNoSelectionAlert) {
            noSelectionAlert
        }
        .confirmationDialog(
            "If you are done selecting please proceed ahead. We can always bring you back here to reselect afresh.",
            isPresented: $showConfirmationAlert,
            titleVisibility: .visible
        ) {
            confirmationDialogActions
        }
        .task({viewModel.fetchBooks()})
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingView(title: msg ?? "Loading...")
                
            case .saving(let msg):
                LoadingView(title: msg ?? "Saving...")
                
            case .saved:
                LoadingView()
                
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchBooks() }
                }
                
            default:
                BookSelectionView(
                    viewModel: viewModel,
                    showNoSelectionAlert: $showNoSelectionAlert,
                    showConfirmationAlert: $showConfirmationAlert
                )
        }
    }
    
    private var noSelectionAlert: Alert {
        Alert(
            title: Text("Oops! No selection found"),
            message: Text("Please select at least 1 song book to proceed to the next step."),
            dismissButton: .default(Text("OK"))
        )
    }
    
    private var confirmationDialogActions: some View {
        Group {
            Button("Proceed") {
                viewModel.saveBooks()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func handleStateChange(_ state: ViewUiState) {
        navigateToNextScreen = .saved == state
    }
}

struct BookSelectionView: View {
    @ObservedObject var viewModel: SelectionViewModel
    @Binding var showNoSelectionAlert: Bool
    @Binding var showConfirmationAlert: Bool

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.books.indices, id: \.self) { index in
                        let selectable = viewModel.books[index]
                        BookItem(
                            book: selectable.data,
                            isSelected: selectable.isSelected
                        ) {
                            viewModel.toggleSelection(for: selectable.data)
                        }
                    }
                }
                .padding()
            }

            Button(action: {
                if viewModel.selectedBooks().isEmpty {
                    showNoSelectionAlert = true
                } else {
                    showConfirmationAlert = true
                }
            }) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Proceed")
                }
                .foregroundColor(.white)
                .padding()
                .background(.primary1)
                .cornerRadius(10)
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    Step1View()
}
