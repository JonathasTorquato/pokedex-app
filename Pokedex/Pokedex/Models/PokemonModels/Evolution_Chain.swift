//
//  Evolution_Chain.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 14/04/22.
//

import Foundation

struct EvolutionChainDTO : Codable{
    var chain : Chain?
}
class Chain : Codable {
    var evolves_to : [Chain]?
    var species : TypeURLDTO?
}
