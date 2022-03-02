//
//  PokemonDTO.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation


class PokemonDTO: Codable{
    let name: String?
    let id: Int?
    let types: [TypeURLDTO2]?
    let sprite: [Sprites]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case types = "types"
        case sprite = "sprites"
        
    }
}
