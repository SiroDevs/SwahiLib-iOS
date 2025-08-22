//
//  PaywallView.swift
//  SwahiLib
//
//  Created by Siro Daves on 22/08/2025.
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    @Binding var showPaywall: Bool
    @State private var offerings: Offerings?

    var body: some View {
        VStack {
            if let package = offerings?.current?.availablePackages.first {
                Text("Upgrade to Premium")
                    .font(.title)
                    .padding()

                Button("Subscribe for \(package.storeProduct.localizedPriceString)") {
                    Purchases.shared.purchase(package: package) { result, info, error, userCancelled in
                        if info?.entitlements["premium"]?.isActive == true {
                            showPaywall = false
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            } else {
                ProgressView("Loading options...")
            }
        }
        .onAppear {
            Purchases.shared.getOfferings { offerings, error in
                self.offerings = offerings
            }
        }
    }
}
