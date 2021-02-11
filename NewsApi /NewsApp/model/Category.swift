//
//  Category.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 10.02.2021.
//

import Foundation

enum Category: String {
    case business, entertainment, general, health, science, sports, technology
    
    static var all: [Category] {
        return [business, entertainment, general, health, science, sports, technology]
    }
}
