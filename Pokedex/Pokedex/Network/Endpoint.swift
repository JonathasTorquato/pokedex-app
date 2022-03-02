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
    }
    
    struct TYPE {
        static let types = "/type"
    }
}
