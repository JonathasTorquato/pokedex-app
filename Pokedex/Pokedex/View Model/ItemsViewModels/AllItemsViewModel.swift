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
    
    func getItemName(name : String, completionSuc : @escaping(ItemDTO)->Void, completionError: @escaping(String)->Void) {
        let nameWithoutSpaces = name.lowercased().replacingOccurrences(of: " ", with: "-")
        Network.getItemByName(name: nameWithoutSpaces) { result in
            switch result {
                
            case .success(let success):
                completionSuc(success)
            case .failure(let error):
                completionError(error.localizedDescription)
            }
        }
    }
    
}
