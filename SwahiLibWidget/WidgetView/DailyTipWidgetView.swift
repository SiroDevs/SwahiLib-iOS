//
//  DailyTipWidgetView.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/10/2025.
//

import WidgetKit
import SwiftUI

struct DailyTipWidgetView : View {
    var entry: DailyTipProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(.mainIcon)
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("Neno la Siku")
            }
            .font(.title3)
            .bold()
            .padding(.bottom, 8)
            
            Text(entry.dailyTip)
                .font(.caption)
            
        }
        .foregroundStyle(.white)
        .containerBackground(for: .widget){
            Color.cyan
        }
    }
}
