//
//  ParentalGateView.swift
//  SwahiLib
//
//  Created by Siro Daves on 28/08/2025.
//

import SwiftUI

struct ParentalGateView: View {
    @State private var answer: String = ""
    @State private var errorMessage: String?
    
    var onSuccess: () -> Void
    
    private let firstNumber = Int.random(in: 5...10)
    private let secondNumber = Int.random(in: 1...5)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Parents Only")
                .font(.title2)
                .bold()
            
            Text("To continue, answer this question:")
                .font(.body)
            
            Text("\(firstNumber) + \(secondNumber) = ?")
                .font(.title3)
                .bold()
            
            TextField("Enter answer", text: $answer)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Continue") {
                if Int(answer) == firstNumber + secondNumber {
                    onSuccess()
                } else {
                    errorMessage = "Incorrect. Try again."
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
}
