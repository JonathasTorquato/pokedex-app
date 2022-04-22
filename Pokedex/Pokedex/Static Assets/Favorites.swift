//
//  FavoritePokemons.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 20/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class Favorites {
    static let favoritePokemonKey = "Favorite Pokemon"
    static let favoritePokemon : BehaviorRelay<[Int]> = BehaviorRelay(value: [])
}
