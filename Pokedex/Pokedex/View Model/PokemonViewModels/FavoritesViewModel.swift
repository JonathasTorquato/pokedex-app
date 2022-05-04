//
//  FavoritesViewModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 22/04/22.
//

import Foundation
import RxRelay

class FavoritesViewModel {
    init(){}
    
    //MARK: - Get Pokemon Methods
    
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
    
    func searchPokemon(search : String, from pokemons : [Int], to list : BehaviorRelay<[Int]>) {
        if search == "" {
            list.accept(pokemons)
            return
        }
        var number = false
        if Int(search) != nil{
            number = true
        }
        list.accept([])
        for pokemonId in pokemons {
            if !number {
                self.getPokemonId(id: pokemonId) { pokemon in
                    if pokemon.name.contains(search.lowercased().replacingOccurrences(of: "-", with: " ")) {
                        var listAp = list.value
                        listAp.append(pokemonId)
                        list.accept(listAp)
                    }
                }
            } else if "\(pokemonId)".contains(search){
                var listAp = list.value
                listAp.append(pokemonId)
                list.accept(listAp)
            }
        }
        
    }
    
}
