//
//  PokedexEntry.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 13/04/22.
//

import Foundation

class PokedexEntry : Codable{
    var flavor_text_entries : [Entry]
    var evolution_chain : EvolutionChain?
    var varieties : [Forms]?
}
class Entry : Codable
{
    var flavor_text : String
    var language : Language
    var version : GenericURLDTO
}
struct Language : Codable{
    var name : String
}
struct EvolutionChain : Codable {
    var url : String?
}
struct Forms : Codable {
    var pokemon : GenericURLDTO?
}
