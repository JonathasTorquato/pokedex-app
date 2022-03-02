//
//  TypeDTO.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation

class TypeDTO: Codable{
    let name: String?
    let id: Int?
    let doubleDamageFrom: [TypeDTO]?
    let halfDamageFrom: [TypeDTO]?
    let halfDamageTo: [TypeDTO]?
    let doubleDamageTo: [TypeDTO]?
    let noDamageTo: [TypeDTO]?
    let noDamageFrom: [TypeDTO]?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
        
    }
}
