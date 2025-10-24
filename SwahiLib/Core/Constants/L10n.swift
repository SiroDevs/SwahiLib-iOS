//
//  L10n.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/08/2025.
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
    
    static func likedWord(for word: String, isLiked: Bool) -> String {
        if isLiked {
            return "Neno \(word) limeongezwa kwa vipendwa"
        } else {
            return "Neno \(word) limeondolewa kutoka kwa vipendwa"
        }
    }
    static func likedSaying(for saying: String, isLiked: Bool) -> String {
        if isLiked {
            return "Msemo \(saying) umeongezwa kwa vipendwa"
        } else {
            return "Msemo \(saying) umeondolewa kutoka kwa vipendwa"
        }
    }
    static func likedProverb(for proverb: String, isLiked: Bool) -> String {
        if isLiked {
            return "Methali \(proverb) imeongezwa kwa vipendwa"
        } else {
            return "Methali \(proverb) imeondolewa kutoka kwa vipendwa"
        }
    }
    static func likedIdiom(for idiom: String, isLiked: Bool) -> String {
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
    static let joinPro = "Jiunge na SwahiLib Pro"
    static let joinProDesc = "Jiunge na SwahiLib Pro, ufurahie utafutaji wa kina, vipengele kadhaa kama vipendwa na alamisho kama njia ya kumuunga mkono developer wa SwahiLib"
    static let leaveReview = "Tupe review"
    static let leaveReviewDesc = "Unaweza kutupa review ili kitumizi hizi kionekane kwa wengine"
    static let resetDataAlert = "Weka upya Data?"
    static let resetDataAlertDesc = "Je, una uhakika unataka kuweka upya data yako yote? Kitendo hiki hakiwezi kutenduliwa."
    static let resetData = "Weka upya Data"
    static let resetDataDesc = "Unaweza kufuta data yote na kufanya uteuzi upya."
    static let contactUs = "Wasiliana nasi"
    static let contactUsDesc = "Iwapo una malalamishi/maoni, tutumie barua pepe. Usikose kuweka picha za skrini (screenshot) nyingi uwezavyo."
}
