//
//  TypePortuguese.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 30/03/22.
//

import Foundation
import UIKit

protocol TypePortugueseUseCase {
    static func getTypePortuguese(name: String,_ label: UILabel?) -> String
}

class TypePortuguese: TypePortugueseUseCase {
    static func getTypePortuguese(name: String,_ label: UILabel? = nil) -> String
    {
        switch name{
        case "bug":
            label?.textColor = .systemGreen //OK
            return "Inseto"
        case "water":
            label?.textColor = .systemBlue   //OK
            return "Água"
        case "normal":
            label?.textColor = .systemGray  //OK
            return "Normal"
        case "fighting":
            label?.textColor = .red     //OK
            return "Lutador"
        case "flying":
            label?.textColor = .systemCyan  //OK
            return "Voador"
        case "poison":
            label?.textColor = .systemPurple    //OK
            return "Venenoso"
        case "ground":
            label?.textColor = .systemBrown //OK
            return "Terrestre"
        case "rock":
            label?.textColor = .systemGray2 //OK
            return "Pedra"
        case "ghost":
            label?.textColor = .purple  //OK
            return "Fantasma"
        case "steel":
            label?.textColor = .blue //OK
            return "Metal"
        case "fire":
            label?.textColor = .systemRed   //OK
            return "Fogo"
        case "grass":
            label?.textColor = .green   //OK
            return "Planta"
        case "electric":
            label?.textColor = UIColor(red: 255/255, green: 205/255, blue: 57/255, alpha: 1)    //OK
            return "Elétrico"
        case "psychic":
            label?.textColor = .magenta   //OK
            return "Psíquico"
        case "ice":
            label?.textColor = .cyan    //OK
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
