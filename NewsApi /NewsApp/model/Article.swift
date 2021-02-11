//
//  Article.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 09.02.2021.
//

import Foundation

struct NewsResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
    let author: String?
    let urlToImage: String?
    let publishedAt: Date?
    let source: Source
    let url: String?
}

struct SourceInfo: Codable {
    let id: String?
    let name: String?
}

struct SourcesResponse: Codable {
    let status: String
    let sources: [Source]
}

struct Source: Codable {
    let name: String?
    let description: String?
    let country: String?
    let category: String?
    let url: String?
    let id: String?
}
