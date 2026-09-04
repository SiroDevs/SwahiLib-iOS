//
//  ParentalGateView.swift
//  SwahiLib
//
//  Created by @sirodevs on 28/08/2025.
//

import SwiftUI

struct ParentalGateView: View {
    @State private var answer: String = ""
    @State private var errorMessage: String?
    @State private var isShaking = false
    @FocusState private var isTextFieldFocused: Bool
    
    var onSuccess: () -> Void
    
    private let firstNumber = Int.random(in: 5...10)
    private let secondNumber = Int.random(in: 1...5)
    
    private var correctAnswer: Int {
        firstNumber + secondNumber
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .symbolRenderingMode(.hierarchical)
                    
                    Text("Wazazi Pekee")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Ili kuendelea, jibu swali hili:")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        ParentalNumberCard(value: firstNumber)
                        Text("+")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        ParentalNumberCard(value: secondNumber)
                        Text("=")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text("?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    
                    TextField("Andika jibu hapa", text: $answer)
                        .keyboardType(.numberPad)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .focused($isTextFieldFocused)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .stroke(isTextFieldFocused ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .overlay(
                            HStack {
                                Spacer()
                                if !answer.isEmpty {
                                    Button(action: {
                                        answer = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 16)
                                }
                            }
                        )
                        .modifier(ParentalShakeEffect(animatableData: isShaking ? 1 : 0))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGray6))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                if let error = errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.1))
                    )
                    .padding(.horizontal)
                }
                
                Button(action: validateAnswer) {
                    HStack {
                        Text("Endelea")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }
    
    private func validateAnswer() {
        guard let userAnswer = Int(answer) else {
            showError("Tafadhali andika nambari tu")
            return
        }
        
        if userAnswer == correctAnswer {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            onSuccess()
        } else {
            showError("Jibu si sahihi. Jaribu tena.")
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
            isShaking = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isShaking = false
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

//#Preview {
//    ParentalGateView(onSuccess: {
//        print("Success!")
//    })
//}
