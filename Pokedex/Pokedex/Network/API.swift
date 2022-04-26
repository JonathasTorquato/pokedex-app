//
//  API.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation
import Moya

enum API {
    case typeURL(url : String)
    case type(idType : Int)
    case pokemonId(idPokemon : Int)
    case pokemonName(pokemonName : String)
    case pokemon
    case pokedexEntry(idPokemon : Int)
    case chain(idChain : Int)
    case chainURL(url : String)
    case items
    case itemId(id : Int)
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
            return Endpoint.POKEMON.pokemons + "/"
        case .typeURL (let url):
            return url
        case .pokedexEntry(idPokemon: let idPokemon):
            return Endpoint.POKEMON.pokemonEntry + "/\(idPokemon)"
        case .chain(idChain: let id):
            return Endpoint.CHAIN.chains + "/\(id)"
        case .chainURL(url: let url):
            var urlAux = url
            var count : Int = 0
            urlAux.removeAll { element in
                if count < Endpoint.baseURL.count {
                    count += 1;
                    return true
                }
                count += 1
                return false
            }
            return urlAux
        case .items:
            return Endpoint.ITEM.items
        case .itemId(id: let id):
            return Endpoint.ITEM.items + "/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        /*switch self {
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
        case .pokedexEntry:
            return .requestPlain
        case .chainURL:
            return .requestPlain
        case .chain:
            return .requestPlain
        case .items:
            return .requestPlain
        case .itemId:*/
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
