//
//  TypeURLDTO.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation

class GenericURLDTO: Codable{
    let url: String
    let name: String
    
}

class AllTypes : Codable {
    let results : [GenericURLDTO]
}
