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
    
    func getPokemonName(name: String, otherId: String, completion: @escaping(PokemonDTO)->Void) {
        Network.getPokemonName(name: name) { result in
            switch result {
                
            case .success(let success):
                completion(success)
            case .failure(_):
                self.getPokemonId(id: self.getIdFromURL(url: otherId)) { pokemon in
                    completion(pokemon)
                }
                
            }
        }
    }
    
    func searchPokemon(search : String, from pokemons : [PokemonDTO]) -> [PokemonDTO]{
        if search == "" {
            return pokemons
        }
        var s = search
        while (s.first ?? " ") == "0"
        {
            s.removeFirst()
        }
        var list : [PokemonDTO] = []
        for pokemon in pokemons {
            if pokemon.id.numberToSpecialNumber().contains(s) || "\(pokemon.name.lowercased().replacingOccurrences(of: " ", with: "-"))".contains(s.lowercased().replacingOccurrences(of: " ", with: "-")){
                list.append(pokemon)
            }
        }
        
        return list
        
    }
    
    func getIdFromURL(url : String) ->Int {
        var newId = url.replacingOccurrences(of: Endpoint.baseURL, with: "")
        newId = newId.replacingOccurrences(of: Endpoint.POKEMON.pokemonEntry.replacingOccurrences(of: "/", with: ""), with: "")
        return Int(newId.replacingOccurrences(of: "/", with: "")) ?? 0
    }
    
}
