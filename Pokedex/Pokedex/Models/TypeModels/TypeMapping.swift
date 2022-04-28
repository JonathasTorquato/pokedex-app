//
//  TypeMapping.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 28/04/22.
//

import Foundation

class TypeMapping {
    static func typeFromDTOToModel(type dto : TypeDTO) -> TypeModel {
        let relations = [
                         ["Dobro de dano de:" : dto.damage_relations.doubleDamageFrom],
                         ["Dobro de dano em:" : dto.damage_relations.doubleDamageTo],
                         ["Metade de dano em:" : dto.damage_relations.halfDamageTo],
                         ["Metade de dano de:" : dto.damage_relations.halfDamageFrom],
                         ["Imune à:" : dto.damage_relations.noDamageFrom],
                         ["Não dá dano em:" : dto.damage_relations.noDamageTo]
                        ]
        return TypeModel(name: dto.name, relacoes: relations)
    }
}
