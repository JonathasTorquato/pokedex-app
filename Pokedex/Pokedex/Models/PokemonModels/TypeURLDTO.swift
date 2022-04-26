//
//  TypeURLDTO.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation

class TypeURLDTO: Codable{
    let url: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
    
}
