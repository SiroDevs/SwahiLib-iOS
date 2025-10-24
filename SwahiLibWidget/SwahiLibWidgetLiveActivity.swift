//
//  SwahiLibWidgetLiveActivity.swift
//  SwahiLibWidget
//
//  Created by @sirodevs on 24/10/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SwahiLibWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SwahiLibWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SwahiLibWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SwahiLibWidgetAttributes {
    fileprivate static var preview: SwahiLibWidgetAttributes {
        SwahiLibWidgetAttributes(name: "World")
    }
}

extension SwahiLibWidgetAttributes.ContentState {
    fileprivate static var smiley: SwahiLibWidgetAttributes.ContentState {
        SwahiLibWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SwahiLibWidgetAttributes.ContentState {
         SwahiLibWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SwahiLibWidgetAttributes.preview) {
   SwahiLibWidgetLiveActivity()
} contentStates: {
    SwahiLibWidgetAttributes.ContentState.smiley
    SwahiLibWidgetAttributes.ContentState.starEyes
}
