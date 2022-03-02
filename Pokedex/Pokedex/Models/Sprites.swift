//
//  Sprites.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import Foundation

class Sprites: Codable
{
    let frontMale: String?
    let backMale: String?
    let frontMaleShiny: String?
    let backMaleShiny: String?
    
    let frontFemale: String?
    let backFemale: String?
    let frontFemaleShiny: String?
    let backFemaleShiny: String?
    
    enum CodingKeys: String, CodingKey {
        
        case frontMale = "front_default"
        case backMale = "back_default"
        case frontMaleShiny = "front_shiny"
        case backMaleShiny = "back_shiny"
        
        case frontFemale = "front_female"
        case backFemale = "back_female"
        case frontFemaleShiny = "front_shiny_female"
        case backFemaleShiny = "back_shiny_female"
        
    }
}
