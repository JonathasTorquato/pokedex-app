//
//  MainViewModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 30/03/22.
//

import Foundation
import SwiftUI

class MainViewModel {
    init() {}
    
    //MARK: - Get Methods
    func getPokemonCount(completion: @escaping(Int)->Void) {
        Network.getPokemonCount { result in
            switch result
            {
            case .success(let response):
                completion(response.count)
            case .failure(let error):
                print(error.localizedDescription)
                completion(0)
            }
        }
    }
    
    func getPokemonId(id: Int, completionSuc: @escaping(PokemonDTO)->Void, completionError: @escaping(String)->Void) {
        Network.getPokemonID(id: id){ result in
            switch result
            {
                
            case .success(let response):
                completionSuc(response)
            case .failure(let error):
                completionError(error.localizedDescription)
            }
        }
    }
    
    func getPokemonName(name: String, completionSuc: @escaping(PokemonDTO)->Void, completionError: @escaping(String)->Void) {
        Network.getPokemonName(name: name) { result in
            switch result {
                
            case .success(let success):
                completionSuc(success)
            case .failure(let error):
                completionError(error.localizedDescription)
            }
        }
    }
    
    func getAllTypes(completion : @escaping([GenericURLDTO])->Void) {
        Network.getAllTypes { result in
            switch result {
                
            case .success(let suc):
                suc.results.removeAll { type in
                    return (type.name == "shadow" || type.name == "unknown")
                }
                completion(suc.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getSelectedType(in url : String, completion : @escaping([PokemonsByType])->Void) {
        Network.getTypeURL(url: url) { result in
            switch result {
                
            case .success(let suc):
                completion(suc.pokemon)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPokemonsType(url : String, completion : @escaping([PokemonsByType])->Void) {
        Network.getTypeURL(url: url) { result in
            switch result {
                
            case .success(let suc):
                completion(suc.pokemon)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getIdFromURL(url : String) ->Int {
        var newId = url.replacingOccurrences(of: Endpoint.baseURL, with: "")
        newId = newId.replacingOccurrences(of: Endpoint.POKEMON.pokemonEntry.replacingOccurrences(of: "/", with: ""), with: "")
        return Int(newId.replacingOccurrences(of: "/", with: "")) ?? 0
    }
    
}
