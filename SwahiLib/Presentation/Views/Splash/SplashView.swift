//
//  SplashView.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(AppAssets.mainIcon)
                .resizable()
                .frame(width: 200, height: 200)

            Text(AppConstants.appTitle)
                .font(.system(size: 50, weight: .bold))
                .kerning(5)
                .foregroundColor(.primary1)
                .padding(.top, 10)

            Spacer()
            Divider()
                .frame(height: 1)
                .padding(.horizontal, 50)
                .background(.primaryDark1)

            Text(AppConstants.appTagline)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.primary1)
            .padding(.top, 10)

            Spacer().frame(height: 20)
        }.padding()
    }
}

#Preview {
    SplashView()
}
