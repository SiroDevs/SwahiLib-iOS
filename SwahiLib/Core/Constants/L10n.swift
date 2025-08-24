//
//  L10n.swift
//  SwahiLib
//
//  Created by Siro Daves on 24/08/2025.
//

struct L10n {
    static let later = "Baadaye"
    static let cancel = "Kataa"
    static let okay = "Sawa"
    static let synonym = "Kisawe"
    static let synonyms = "Visawe"
    static let featureLocked = "Kipengele hiki kimefungwa"
    static let featureLockedDesc = "Jiunge na SwahiLib PRO ili uweze kutumia kipengele (feature) hiki miongoni mwa vipengele vingine. Kujiunga na PRO ni kumuunga mkono msanidi program (developer) wa kitumizi (app) hii. Asante"
    static func featureLockedDescXtra(feature: String) -> String {
        return "Jiunge na SwahiLib PRO ili uweze \(feature)"
    }
    
    static let featureViewWordSynonym = "kufungua visawe vya neno unalotazama miongoni kwa vipengele vingine."
    static let featureViewProverbSynonym = "kufungua visawe vya methali unayotazama miongoni kwa vipengele vingine."
    
    static func favoriteWord(for word: String, isLiked: Bool) -> String {
        if isLiked {
            return "Neno \(word) limeongezwa kwa vipendwa"
        } else {
            return "Neno \(word) limeondolewa kutoka kwa vipendwa"
        }
    }
    static func favoriteSaying(for saying: String, isLiked: Bool) -> String {
        if isLiked {
            return "Msemo \(saying) umeongezwa kwa vipendwa"
        } else {
            return "Msemo \(saying) umeondolewa kutoka kwa vipendwa"
        }
    }
    static func favoriteProverb(for proverb: String, isLiked: Bool) -> String {
        if isLiked {
            return "Methali \(proverb) imeongezwa kwa vipendwa"
        } else {
            return "Methali \(proverb) imeondolewa kutoka kwa vipendwa"
        }
    }
    static func favoriteIdiom(for idiom: String, isLiked: Bool) -> String {
        if isLiked {
            return "Nahau \(idiom) imeongezwa kwa vipendwa"
        } else {
            return "Nahau \(idiom) imeondolewa kutoka kwa vipendwa"
        }
    }
    
    static let wordKiswa = "Neno la Kiswahili"
    static let idiomKiswa = "Nahau ya Kiswahili"
    static let sayingKiswa = "Msemo wa Kiswahili"
    static let proverbKiswa = "Methali ya Kiswahili"
}
