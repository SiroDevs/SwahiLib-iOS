//
//  AppConstants.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct AppConstants {
    static let appTitle = "SwahiLib"
    static let appCredits1 = "Siro"
    static let appCredits2 = "Titus"
}

extension Bundle {
    var supabaseUrl: String {
        return infoDictionary?["SUPABASE_URL"] as? String ?? ""
    }

    var supabaseAnonKey: String {
        return infoDictionary?["SUPABASE_ANON_KEY"] as? String ?? ""
    }
}
