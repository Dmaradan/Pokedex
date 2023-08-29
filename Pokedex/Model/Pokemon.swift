//
//  Pokemon.swift
//  Pokedex
//
//  Created by Diego Martin on 8/23/23.
//

import Foundation

struct Pokemon: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
}
