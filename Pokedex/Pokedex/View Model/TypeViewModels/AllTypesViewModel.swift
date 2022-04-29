//
//  AllTypesViewModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 28/04/22.
//

import Foundation

class AllTypesViewModel {
    init() {}
    
    func getTypes(completion : @escaping([TypeURLDTO]) -> Void) {
        Network.getAllTypes { result in
            switch result {
                
            case .success(let suc):
                completion(suc.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func getTypeFromURL (url : String, completion : @escaping(TypeModel) -> Void) {
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
