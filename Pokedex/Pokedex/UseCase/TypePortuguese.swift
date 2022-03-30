//
//  TypePortuguese.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 30/03/22.
//

import Foundation
import UIKit

protocol TypePortugueseUseCase{
    static func getTypePortuguese(name: String,_ label: UILabel?) -> String
}

class TypePortuguese: TypePortugueseUseCase{
    
    init(){}
    
    static func getTypePortuguese(name: String,_ label: UILabel?) -> String
    {
        switch name{
        case "bug":
            label?.textColor = .systemGreen
            return "Inseto"
        case "water":
            label?.textColor = .systemBlue
            return "Água"
        case "normal":
            label?.textColor = .systemGray
            return "Normal"
        case "fighting":
            label?.textColor = .red
            return "Lutador"
        case "flying":
            label?.textColor = .systemCyan
            return "Voador"
        case "poison":
            label?.textColor = .systemPurple
            return "Venenoso"
        case "ground":
            label?.textColor = .systemBrown
            return "Terrestre"
        case "rock":
            label?.textColor = .systemGray2
            return "Pedra"
        case "ghost":
            label?.textColor = .purple
            return "Fantasma"
        case "steel":
            label?.textColor = .blue
            return "Metal"
        case "fire":
            label?.textColor = .systemRed
            return "Fogo"
        case "grass":
            label?.textColor = .green
            return "Planta"
        case "electric":
            label?.textColor = .yellow
            return "Elétrico"
        case "psychic":
            label?.textColor = .magenta
            return "Psíquico"
        case "ice":
            label?.textColor = .cyan
            return "Gelo"
        case "dragon":
            label?.textColor = .orange
            return "Dragão"
        case "dark":
            label?.textColor = .systemTeal
            return "Noturno"
        case "fairy":
            label?.textColor = .systemPink
            return "Fada"
        case "unknown":
            label?.textColor = .label
            return "Desconhecido"
        case "shadow":
            label?.textColor = .label
            return "Sombra"
        default:
            return "Erro"
        }
    }
    
}
