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

            HStack {
                Text("with ")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(.primary1)
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primaryDark1)
                Text(" from")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(.primary1)
            }

            HStack {
                Text(AppConstants.appCredits1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primaryDark1)
                Text(" & ")
                    .font(.system(size: 20))
                    .foregroundColor(.primary1)
                Text(AppConstants.appCredits2)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primaryDark1)
            }
            .padding(.top, 10)

            Spacer().frame(height: 20)
        }.padding()
    }
}

#Preview {
    SplashView()
}
