//
//  LoadingView.swift
//  SwahiLib
//
//  Created by @sirodevs on 04/05/2025.
//

import SwiftUI
import Lottie

struct LoadingState: View {
    var title: String = ""
    var fileName: String = "opener-loading"
    var showProgress: Bool = false
    var progressValue: Int = 0

    var body: some View {
        VStack(spacing: 24) {
            LottieView(name: fileName).frame(width: 300, height: 300)

            Text(title)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.onPrimaryContainer)

            if showProgress {
                VStack(spacing: 8) {
                    HStack {
                        ProgressView(value: Double(progressValue) / 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: .primary1))
                            .frame(height: 20)
                        Spacer().frame(width: 8)
                        Text("\(progressValue) %")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.onSurface)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.onPrimary)
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingState(
        title: "Inapakia data ...",
        fileName: "opener-loading",
        showProgress: true,
        progressValue: 65,
    )
}
