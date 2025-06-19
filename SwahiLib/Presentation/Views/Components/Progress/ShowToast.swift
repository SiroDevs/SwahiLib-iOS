//
//  ShowToast.swift
//  SwahiLib
//
//  Created by Siro Daves on 29/05/2025.
//

import UIKit
import SwiftUI

extension UIView {
    func showToast(message: String, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.alpha = 0.0
        toastLabel.numberOfLines = 0
        
        let textSize = toastLabel.intrinsicContentSize
        let labelWidth = min(textSize.width + 40, self.frame.width - 40)
        let labelHeight = textSize.height + 20
        toastLabel.frame = CGRect(x: (self.frame.width - labelWidth) / 2,
                                  y: self.frame.height - labelHeight - 80,
                                  width: labelWidth,
                                  height: labelHeight)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
