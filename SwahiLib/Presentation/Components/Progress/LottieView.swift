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
        let containerView = UIView()
        let animationView = LottieAnimationView()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])

        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            let animation = LottieAnimation.filepath(path)
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
        } else {
            print("⚠️ Lottie animation '\(name).json' not found in bundle.")
        }

        return containerView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
