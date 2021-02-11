//
//  NewsApiParameter.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 10.02.2021.
//

import Foundation

enum NewsApiParameter {
    case country(_ country: Country)
    case category(_ category: Category)
    case page(_ page: Int)
    case pagesize(_ pagesize: Int)
    case apiKey
    case search(_ searchReq: String)
    case source(_ source: Source)
    
    var key: String {
        switch self {
        case .country(_):
            return "country"
        case .category(_):
            return "category"
        case .page(_):
            return "page"
        case .apiKey:
            return "apiKey"
        case .pagesize(_):
            return "pageSize"
        case .search(_):
            return "q"
        case .source(_):
            return "sources"
        }
    }
    
    var value: String {
        switch self {
        case .country(let country):
            return country.rawValue
        case .category(let category):
            return "\(category.rawValue)"
        case .page(let page):
            return "\(page)"
        case .apiKey:
            return "34846b91830344d8b4556fc73f891b64"
        case .pagesize(let pagesize):
            return "\(pagesize)"
        case .search(let query):
            return query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query
        case .source(let source):
            return source.id ?? source.name ?? ""
        }
    }
    
    var asUrlQueryItem: URLQueryItem {
        return URLQueryItem(name: key, value: value)
    }
}
