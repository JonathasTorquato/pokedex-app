//
//  Endpoint.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation

struct Endpoint {
    static let baseURL = Environment.defaultEnvironment.string(.baseUrl)
    
    struct POKEMON {
        static let pokemons = "/pokemon"
        static let pokemonEntry = "/pokemon-species"
    }
    
    struct TYPE {
        static let types = "/type"
    }
    struct CHAIN {
        static let chains = "/evolution-chain"
    }
    
    struct ITEM {
        static let items = "/item"
        static let itemCategory = "/item-category"
    }
}
