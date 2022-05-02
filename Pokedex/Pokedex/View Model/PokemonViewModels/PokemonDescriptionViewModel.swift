//
//  PokemonDescriptionViewModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 22/04/22.
//

import Foundation

//MARK: - Declarations
class PokemonDescriptionViewModel {
    fileprivate let defaults = UserDefaults.standard
    var urlType1 : TypeURLDTO?
    var urlType2 : TypeURLDTO?
    init(){}
}

//MARK: - Methods
extension PokemonDescriptionViewModel {
    
    //MARK: - User Defaults
    func saveUserDefatuls(value : Any, for key: String) {
        defaults.set(value, forKey: key)
    }
    
    func favoritePokemon(pokemonId: Int) -> Bool {
        var favorites = Favorites.favoritePokemon.value
        var added = false
        for id in favorites {
            if id == pokemonId {
                added = true
                favorites.removeAll { ids in
                    if ids == id {
                        return true
                    }
                    return false
                }
            }
        }
        if !added {
            favorites.append(pokemonId)
        }
        favorites.sort()
        
        self.saveUserDefatuls(value: favorites, for: Favorites.favoritePokemonKey)
        Favorites.favoritePokemon.accept(favorites)
        return !added
    }
    
    func typeURL(name type : String, completion : @escaping(TypeModel)->Void) {
        var url = ""
        if let type1 = urlType1, type == TypePortuguese.getTypePortuguese(name: type1.name) {
            url = type1.url
        }
        else if let type2 = urlType2, type == TypePortuguese.getTypePortuguese(name: type2.name) {
            url = type2.url
        }
        if url != "" {
            Network.getTypeURL(url: url) { result in
                switch result {
                    
                case .success(let suc):
                    let typeM = TypeMapping.typeFromDTOToModel(type: suc)
                    completion(typeM)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
}
