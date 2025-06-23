//
//  AppConstants.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct AppConstants {
    static let appTitle = "SwahiLib"
    static let appTagline = "Kiswahili Kitukuzwe"
}

struct SupabaseSecrets {
    static let url: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["SUPABASE_URL"] as? String else {
            fatalError("Missing SUPABASE_URL in Secrets.plist")
        }
        return value
    }()

    static let anonKey: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["SUPABASE_ANON_KEY"] as? String else {
            fatalError("Missing SUPABASE_ANON_KEY in Secrets.plist")
        }
        return value
    }()
}

