//
//  TypeModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 28/04/22.
//

import Foundation

class TypeModel {
    var name : String
    var relacoes : [[String:[GenericURLDTO]]]
    
    init(name : String, relacoes : [[String:[GenericURLDTO]]]) {
        self.name = name
        self.relacoes = relacoes
    }
}
