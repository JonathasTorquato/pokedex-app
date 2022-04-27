//
//  TypeDTO.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation

class TypeDTO: Codable{
    let name: String
    var damage_relations : DamageRelations
}
struct DamageRelations : Codable {
    let doubleDamageFrom: [TypeURLDTO]
    let halfDamageFrom: [TypeURLDTO]
    let halfDamageTo: [TypeURLDTO]
    let doubleDamageTo: [TypeURLDTO]
    let noDamageTo: [TypeURLDTO]
    let noDamageFrom: [TypeURLDTO]
    
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
    }
}
