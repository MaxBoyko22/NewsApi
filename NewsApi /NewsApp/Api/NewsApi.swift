//
//  NewsApi.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 09.02.2021.
//

import Foundation


struct APIConstants {
   
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

enum Endpoint {
    case topHeadLines
    case everything
    case sources
    
    var baseUrl: URL {
        URL(string: "https://newsapi.org/v2/")!
    }
    
    var path: String {
        switch self {
        case .topHeadLines:
            return "top-headlines"
        case .everything:
            return "everything"
        case .sources:
            return "sources"
        }
    }
    
    func getAbsoluteURL(params: [URLQueryItem]) -> URL? {
        let queryUrl = baseUrl.appendingPathComponent(path)
        let components = URLComponents(url: queryUrl, resolvingAgainstBaseURL: true)
        
        guard var urlComponents = components else {
            return nil
        }
        
        urlComponents.queryItems = params
        
        return urlComponents.url
    }
}

