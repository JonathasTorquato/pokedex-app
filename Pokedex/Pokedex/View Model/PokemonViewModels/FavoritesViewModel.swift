//
//  FavoritesViewModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 22/04/22.
//

import Foundation

class FavoritesViewModel {
    init(){}
    
    func getPokemonId(id: Int, completion: @escaping(PokemonDTO)->Void)
    {
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
    
    func getPokemonName(name: String, completion: @escaping(PokemonDTO)->Void){
        Network.getPokemonName(name: name) { result in
            switch result {
                
            case .success(let success):
                completion(success)
            case .failure(let error):
                print("Erro" + error.localizedDescription)
            }
        }
    }
    
}
