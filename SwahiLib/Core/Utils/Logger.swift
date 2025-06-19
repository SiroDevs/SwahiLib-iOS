//
//  Logger.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

protocol LoggerProtocol {
    func log(_ message: String)
}

final class Logger: LoggerProtocol {
    func log(_ message: String) {
        print("LOG: \(message)")
    }
}
