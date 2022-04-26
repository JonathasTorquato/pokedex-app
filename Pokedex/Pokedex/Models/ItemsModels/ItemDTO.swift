//
//  ItemDTO.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 25/04/22.
//

import Foundation


class ItemDTO : Codable {
    var name : String
    var sprites : ItemSprite
    var effect_entries : [ItemEffect]
    
}

struct ItemEffect : Codable {
    var effect : String
    var short_effect : String
}

struct ItemSprite : Codable {
    var defaultSprite : String
    enum CodingKeys: String, CodingKey {
        case defaultSprite = "default"
    }
}
