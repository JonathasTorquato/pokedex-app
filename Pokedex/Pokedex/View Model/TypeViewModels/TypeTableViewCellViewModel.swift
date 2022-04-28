//
//  TypeTableViewCellViewModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 28/04/22.
//

import Foundation

class TypeTableViewCellViewModel {
    init() {}
    
    func retrieveType(url : String, completion : @escaping(TypeModel)->Void) {
        Network.getTypeURL(url: url) { result in
            switch result {
                
            case .success(let suc):
                completion(TypeMapping.typeFromDTOToModel(type: suc))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
