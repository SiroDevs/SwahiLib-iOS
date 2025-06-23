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
            LottieView(name: fileName).frame(width: 200, height: 200)

            Text(title)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.primaryDark2)

            if showProgress {
                VStack(spacing: 8) {
                    HStack {
                        ProgressView(value: Double(progressValue) / 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: .primary1))
                            .frame(height: 8)
                        Spacer().frame(width: 8)
                        Text("\(progressValue) %")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primaryDark3)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.accent2)
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingState(
        title: "Inapakia data ...",
        fileName: "opener-loading",
    )
}
