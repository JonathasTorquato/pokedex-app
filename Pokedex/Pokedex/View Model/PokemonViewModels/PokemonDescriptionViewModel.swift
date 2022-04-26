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
    
    init(){}
}

//MARK: - Methods
extension PokemonDescriptionViewModel {
    
    //MARK: - User Defaults
    func saveUserDefatuls(value : Any, for key: String) {
        defaults.set(value, forKey: key)
    }
    
}
