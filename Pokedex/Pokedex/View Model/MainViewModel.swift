//
//  MainViewModel.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 30/03/22.
//

import Foundation

class MainViewModel{
    init(){}
    func getPokemonCount(completion: @escaping(Int)->Void)
    {
        Network.getPokemonCount { result in
            switch result
            {
            case .success(let response):
                completion(response.count ?? 0)
            case .failure(let error):
                print(error.localizedDescription)
                completion(0)
            }
        }
    }
}
