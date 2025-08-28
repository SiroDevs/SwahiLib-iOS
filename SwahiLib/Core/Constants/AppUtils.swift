//
//  AppUtils.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation
import SwiftUI

class AppUtils {
    static func sendEmail() {
        let subject = "SLib Feedback"
        let body = "Hi, \n\nI would like share some things about the app..."
        let email = "futuristicken@gmail.com"
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
