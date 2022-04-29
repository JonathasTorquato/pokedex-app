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
    
    func getPokemonId(id: Int, completion: @escaping(PokemonDTO)->Void) {
        Network.getPokemonID(id: id){ result in
            switch result
            {
                
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPokemonName(name: String, completion: @escaping(PokemonDTO)->Void) {
        Network.getPokemonName(name: name) { result in
            switch result {
                
            case .success(let success):
                completion(success)
            case .failure(let error):
                print("Erro" + error.localizedDescription)
            }
        }
    }
    
    func getAllTypes(completion : @escaping([TypeURLDTO])->Void) {
        Network.getAllTypes { result in
            switch result {
                
            case .success(let suc):
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
    
}
