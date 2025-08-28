//
//  HomeView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: MainViewModel = {
        DiContainer.shared.resolve(MainViewModel.self)
    }()
    
    @State private var showPaywall: Bool = false
    
    @State private var showParentalGate = false
    @State private var firstNumber = Int.random(in: 5...10)
    @State private var secondNumber = Int.random(in: 1...5)
    @State private var answer: String = ""
    @State private var errorMessage: String?
    
    var body: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                LoadingState(
                    title: "Inapakia data ...",
                    fileName: "opener-loading",
                )
            
            case .filtered:
                TabView {
                    HomeSearch(viewModel: viewModel)
                        .tabItem {
                            Label("Tafuta", systemImage: "magnifyingglass")
                        }
                    
                    if viewModel.activeSubscriber {
                        HomeLikes(viewModel: viewModel)
                            .tabItem {
                                Label("Vipendwa", systemImage: "heart.fill")
                            }
                    }
                    SettingsView(viewModel: viewModel)
                        .tabItem {
                            Label("Mipangilio", systemImage: "gear")
                        }
                }
                .onAppear {
                    showPaywall = !viewModel.activeSubscriber
                    viewModel.promptReview()
                }
//                .alert("Parents Only", isPresented: $showParentalGate, actions: {
//                    TextField("\(firstNumber) + \(secondNumber) = ?", text: $answer)
//                        .keyboardType(.numberPad)
//
//                    Button("Continue") {
//                        if Int(answer) == firstNumber + secondNumber {
//                            // reset state
//                            errorMessage = nil
//                            answer = ""
//                            firstNumber = Int.random(in: 5...10)
//                            secondNumber = Int.random(in: 1...5)
//
//                            showParentalGate = false
//                            showPaywall = true
//                        } else {
//                            errorMessage = "Incorrect. Try again."
//                        }
//                    }
//
//                    Button("Cancel", role: .cancel) {
//                        answer = ""
//                        errorMessage = nil
//                    }
//                }, message: {
//                    if let error = errorMessage {
//                        Text(error)
//                    } else {
//                        Text("To continue, answer the question above.")
//                    }
//                })
                .sheet(isPresented: $showPaywall) {
                    ParentalGateView {
                        DispatchQueue.main.async {
                            showPaywall = true
                        }
                    }
                }
                .sheet(isPresented: $showPaywall) {
                    #if !DEBUG
                    PaywallView(displayCloseButton: true)
                    #endif
                }

//                .sheet(isPresented: $showPaywall) {
//                    ParentalGateView(onSuccess: {
//                        viewModel.updateParentalGate(value: true)
//                        PaywallView(displayCloseButton: true)
//                    })
//                    #if !DEBUG
//                    if viewModel.showParentalGate {
//                        ParentalGateView {
//                            viewModel.showParentalGate = false
//                        }
//                                                PaywallView(displayCloseButton: true)
//                    }
//                    #endif
//                }
               
            case .error(let msg):
                ErrorState(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                LoadingState(
                    title: "Inapakia data ...",
                    fileName: "circle-loader",
                )
        }
    }
}
