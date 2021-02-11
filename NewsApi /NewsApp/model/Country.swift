//
//  Country.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 10.02.2021.
//

import Foundation

enum Country: String {
    case ar, au, us, ru, ca, br
    
    static var all: [Country] = [ar, au, us, ru, ca, br]
    
    var countryLang: String  {
        switch self {
        case .ar:
            return "es"
        case .au:
            return "en"
        case .us:
            return "en"
        case .ru:
            return "ru"
        case .ca:
            return "en"
        case .br:
            return "es"
        }
//        "ar": "es",  // argentina
//        "au": "en",  // australia
//        "br": "es",  // brazil
//        "ca": "en",  // canada
//        "cn": "cn",  // china
//        "de": "de",  // germany
//        "es": "es",  // spain
//        "fr": "fr",  // france
//        "gb": "en",  // unitedKingdom
//        "hk": "cn",  // hongKong
//        "ie": "en",  // ireland
//        "in": "en",  // india
//        "is": "en",  // iceland
//        "il": "he",  // israil for sources - language
//        "it": "it",  // italy
//        "nl": "nl",  // netherlands
//        "no": "no",  // norway
//        "ru": "ru",  // russia
//        "sa": "ar",  // saudiArabia
//        "us": "en",  // unitedStates
//        "za": "en"   // southAfrica
    }
}
