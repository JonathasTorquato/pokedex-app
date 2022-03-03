//
//  API.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation
import Moya

enum API {
    case typeURL(url: String)
    case type(idType: Int)
    case pokemonId(idPokemon: Int)
    case pokemonName(pokemonName: String)
    case pokemon
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    
    var path: String {
        switch self {
        case .type(idType: let id):
            return Endpoint.TYPE.types + "/\(id)"
        case .pokemonId(idPokemon: let idPoke):
            return Endpoint.POKEMON.pokemons + "/\(idPoke)"
        case .pokemonName(pokemonName: let name):
            return Endpoint.POKEMON.pokemons + "/\(name)"
        case .pokemon:
            return Endpoint.POKEMON.pokemons
        case .typeURL (let url):
            return url
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .type:
            return .get
        case .pokemonId:
            return .get
        case .pokemonName:
            return .get
        case .pokemon:
            return .get
        case .typeURL:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .type:
            return .requestPlain
        case .pokemonId:
            return .requestPlain
        case .pokemonName:
            return .requestPlain
        case .pokemon:
            return .requestPlain
        case .typeURL:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
