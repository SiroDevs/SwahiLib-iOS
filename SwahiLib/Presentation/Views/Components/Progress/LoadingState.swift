//
//  LoadingView.swift
//  SwahiLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI
import Lottie

struct LoadingState: View {
    let title: String
    let fileName: String
    var showProgress: Bool = false
    var progressValue: Int = 0

    var body: some View {
        VStack(spacing: 24) {
            LottieView(name: fileName)
                .frame(width: 250, height: 250)

            Text(title)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(Color("primaryDark1"))

            if showProgress {
                VStack(spacing: 8) {
                    HStack {
                        ProgressView(value: Double(progressValue) / 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color("primary")))
                            .frame(height: 8)
                        Spacer().frame(width: 8)
                        Text("\(progressValue) %")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("primaryDark2"))
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("accent1"))
        .ignoresSafeArea()
    }
}

struct ErrorState: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.red)
                .padding()
            
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    LoadingState(
        title: "Inapakia data ...",
        fileName: "opener-loading",
    )
}
