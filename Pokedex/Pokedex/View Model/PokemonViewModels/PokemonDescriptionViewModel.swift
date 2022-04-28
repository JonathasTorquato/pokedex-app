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
