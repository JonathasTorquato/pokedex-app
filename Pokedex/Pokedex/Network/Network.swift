//
//  Network.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 11/05/22.
//

import Foundation
import Moya

class Network {
    
    fileprivate static let provider = MoyaProvider<API>()
    
    static func getPokemonID(id: Int, completion: @escaping(Result<PokemonDTO, Error>)->Void){
        provider.request(.pokemonId(idPokemon: id)) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let pokemon = try decoder.decode(PokemonDTO.self, from: suc.data)
                    completion(.success(pokemon))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getPokemonEntry(idPokemon: Int, completion: @escaping(Result<PokedexEntry, Error>)->Void){
        provider.request(.pokedexEntry(idPokemon: idPokemon)) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let entry = try decoder.decode(PokedexEntry.self, from: suc.data)
                    completion(.success(entry))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getPokemonChain(url : String, completion: @escaping(Result<EvolutionChainDTO, Error>)->Void){
        provider.request(.chainURL(url: url)) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let chain = try decoder.decode(EvolutionChainDTO.self, from: suc.data)
                    completion(.success(chain))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getTypeURL(url : String, completion: @escaping(Result<TypeDTO, Error>)->Void){
        provider.request(.typeURL(url: url.replacingOccurrences(of: Endpoint.baseURL, with: ""))) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let type = try decoder.decode(TypeDTO.self, from: suc.data)
                    completion(.success(type))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getAllTypes(completion: @escaping(Result<AllTypes, Error>)->Void){
        provider.request(.types) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let listType = try decoder.decode(AllTypes.self, from: suc.data)
                    completion(.success(listType))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getAllItems(completion: @escaping(Result<ItemResults, Error>)->Void){
        provider.request(.items) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let listItem = try decoder.decode(ItemResults.self, from: suc.data)
                    completion(.success(listItem))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getItemById(id: Int, completion: @escaping(Result<ItemDTO, Error>)->Void){
        provider.request(.itemId(id: id)) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let item = try decoder.decode(ItemDTO.self, from: suc.data)
                    completion(.success(item))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func getItemByName(name: String, completion: @escaping(Result<ItemDTO, Error>)->Void){
        provider.request(.itemName(name: name)) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let item = try decoder.decode(ItemDTO.self, from: suc.data)
                    completion(.success(item))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getCategoryById(id: Int, completion: @escaping(Result<ItemCategory, Error>)->Void){
        provider.request(.itemCategoryId(id: id)) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let category = try decoder.decode(ItemCategory.self, from: suc.data)
                    completion(.success(category))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getPokemonCount(completion: @escaping(Result<PokemonCount, Error>)->Void){
        provider.request(.pokemon) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let count = try decoder.decode(PokemonCount.self, from: suc.data)
                    completion(.success(count))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func getPokemonName(name: String, completion: @escaping(Result<PokemonDTO, Error>)->Void){
        provider.request(.pokemonName(pokemonName: name)) { result in
            switch result {
                
            case .success(let suc):
                do {
                    let decoder = JSONDecoder()
                    let pokemon = try decoder.decode(PokemonDTO.self, from: suc.data)
                    completion(.success(pokemon))
                }catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
