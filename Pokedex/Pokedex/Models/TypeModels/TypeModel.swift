//
//  TypeModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 28/04/22.
//

import Foundation

class TypeModel {
    var name : String
    var relacoes : [[String:[TypeURLDTO]]]
    
    init(name : String, relacoes : [[String:[TypeURLDTO]]]) {
        self.name = name
        self.relacoes = relacoes
    }
}
