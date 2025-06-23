//
//  LottieView.swift
//  SwahiLib
//
//  Created by Siro Daves on 23/06/2025.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> some UIView {
        let animationView = LottieAnimationView()

        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            let animation = LottieAnimation.filepath(path)
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
        } else {
            print("⚠️ Lottie animation '\(name).json' not found in bundle.")
        }

        return animationView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
