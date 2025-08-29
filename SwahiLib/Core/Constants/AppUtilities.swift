//
//  AppUtils.swift
//  SwahiLib
//
//  Created by Siro Daves on 28/08/2025.
//

import Foundation
import SwiftUI

class AppUtilities {
    static func sendEmail() {
        let subject = "Maoni ya SwahiLib"
        let body = "Habari, \n\nNingependa kushirikisha jambo fulani..."

        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        if let url = URL(string: "mailto:\(AppConstants.supportEmail)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func capitalize(str: String?) -> String {
        guard let str = str, !str.isEmpty else { return "" }
        return str.prefix(1).uppercased() + str.dropFirst()
    }
    
    func truncateString(cutoff: Int, myString: String) -> String {
        let words = myString.split(separator: " ")
        if myString.count > cutoff {
            if myString.count - words.last!.count < cutoff {
                return myString.replacingOccurrences(of: String(words.last!), with: "")
            } else {
                return String(myString.prefix(cutoff))
            }
        } else {
            return ""//myString.trim()
        }
    }
    
}
