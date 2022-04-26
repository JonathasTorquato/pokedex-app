//
//  File.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 25/04/22.
//

import Foundation

class AllItemsViewModel {
    init(){}
    
    func getItems(completion: @escaping(ItemResults)->Void) {
        Network.getAllItems { result in
            switch result {
                
            case .success(let items):
                completion(items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getItemId(id : Int, completion : @escaping(ItemDTO)->Void) {
        Network.getItemById(id: id) { result in
            switch result {
                
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
