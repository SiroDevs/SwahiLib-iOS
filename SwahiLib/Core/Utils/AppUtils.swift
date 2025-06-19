//
//  AppUtils.swift
//  SwahiLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation
import SwiftUI

// Theme Mode String
func getThemeModeString(themeMode: UIUserInterfaceStyle) -> String {
    switch themeMode {
    case .light:
        return "Light"
    case .dark:
        return "Dark"
    default:
        return "System Theme"
    }
}

// Filter String
func filterString(input: String) -> String? {
    let regex = try? NSRegularExpression(pattern: ": (.+?) :", options: [])
    if let match = regex?.firstMatch(in: input, options: [], range: NSRange(input.startIndex..., in: input)) {
        let range = match.range(at: 1)
        if let swiftRange = Range(range, in: input) {
            return String(input[swiftRange])
        }
    }
    return input
}

// Try JSON Decode
func tryJsonDecode(source: String) -> Any? {
    let data = source.data(using: .utf8)
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
        return jsonObject
    } catch {
        return nil
    }
}

// Get Frequency Params
func getFrequencyParams(frequencies: inout [String], productFrequency: [String]) {
    for item in productFrequency {
        switch item {
        case "1": frequencies.append("Monthly")
        case "3": frequencies.append("Quarterly")
        case "6": frequencies.append("Biannually")
        case "12": frequencies.append("Annually")
        case "99": frequencies.append("Single Premium")
        default: break
        }
    }
}

// Check if Keyboard is Showing
func isKeyboardShowing(context: UIViewController) -> Bool {
    return context.view.window?.isKeyWindow == true && context.view.bounds.height - context.view.safeAreaInsets.bottom > 0
}

// Close Keyboard
func closeKeyboard(context: UIViewController) {
    context.view.endEditing(true)
}

// Text Validator
func textValidator(value: String?) -> String? {
    if value?.isEmpty ?? true {
        return "This field is required"
    }
    return nil
}

// Check if Numeric
func isNumeric(s: String?) -> Bool {
    guard let s = s else { return false }
    return Double(s) != nil
}

// String Extension for Camel Case
extension String {
    func camelCase() -> String {
        return self.prefix(1).uppercased() + self.dropFirst().lowercased().replacingOccurrences(of: "_", with: "")
    }
}

// Generate Dropdown Items
func generateDropDownItems(initial: String = "", lowerLimit: Int?, upperLimit: Int?, incremental: Bool = true, minLength: Int = 2) -> [String] {
    var temp: [String] = [initial]
    var items: [String] = []

    if incremental {
        for i in lowerLimit!..<upperLimit! + 1 {
            temp.append(String(i))
        }
    } else {
        for i in (upperLimit!..<lowerLimit!).reversed() {
            temp.append(String(i))
        }
    }

    for item in temp {
        if item.count < minLength {
            items.append("0\(item)")
        } else {
            items.append(item)
        }
    }

    return items
}

// Capitalize First Letter
func capitalize(str: String?) -> String {
    guard let str = str, !str.isEmpty else { return "" }
    return str.prefix(1).uppercased() + str.dropFirst()
}

// Truncate String
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

// Truncate with Ellipsis
func truncateWithEllipsis(cutoff: Int, myString: String) -> String {
    return myString.count <= cutoff ? myString : "\(myString.prefix(cutoff))..."
}

// Refine Title
func refineTitle(txt: String) -> String {
    return txt.replacingOccurrences(of: "''", with: "'")
}

// Refine Content
func refineContent(txt: String) -> String {
    return txt.replacingOccurrences(of: "''", with: "'").replacingOccurrences(of: "#", with: " ")
}

// Song Item Title
func songItemTitle(number: Int, title: String) -> String {
    return number != 0 ? "\(number). \(refineTitle(txt: title))" : refineTitle(txt: title)
}

// Song Verses
func getSongVerses(songContent: String) -> [String] {
    return songContent.split(separator: "##").map { $0.replacingOccurrences(of: "#", with: "\n") }
}

// Song Copy String
func songCopyString(title: String, content: String) -> String {
    return "\(title)\n\n\(content)"
}

// Book Count String
func bookCountString(title: String, count: Int) -> String {
    return "\(title) (\(count))"
}

// Lyrics String
func lyricsString(lyrics: String) -> String {
    return lyrics.replacingOccurrences(of: "#", with: "\n").replacingOccurrences(of: "''", with: "'")
}

// Song Viewer Title
func songViewerTitle(number: Int, title: String, alias: String) -> String {
    var songTitle = "\(number). \(refineTitle(txt: title))"
    if alias.count > 2 && title != alias {
        songTitle = "\(songTitle) (\(refineTitle(txt: alias)))"
    }
    return songTitle
}

// Song Share String
func songShareString(title: String, content: String) -> String {
    return "\(title)\n\n\(content)\n\nvia #SwahiLib https://swahilib.vercel.app"
}

// Verse of String
func verseOfString(number: String, count: Int) -> String {
    return "VERSE \(number) of \(count)"
}

// Get Font Size
func getFontSize(characters: Int, height: Double, width: Double) -> Double {
    return sqrt((height * width) / Double(characters))
}
