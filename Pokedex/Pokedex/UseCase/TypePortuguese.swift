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
            label?.textColor = UIColor(red: CGFloat(160)/CGFloat(255), green: CGFloat(187)/CGFloat(255), blue: CGFloat(69)/CGFloat(255), alpha: 1) //OK
            return "Inseto"
        case "water":
            label?.textColor = UIColor(red: CGFloat(0)/CGFloat(255), green: CGFloat(70)/CGFloat(255), blue: CGFloat(155)/CGFloat(255), alpha: 1)   //OK
            return "Água"
        case "normal":
            label?.textColor = .systemGray  //OK
            return "Normal"
        case "fighting":
            label?.textColor = UIColor(red: CGFloat(255)/CGFloat(255), green: CGFloat(85)/CGFloat(255), blue: CGFloat(28)/CGFloat(255), alpha: 1)     //OK
            return "Lutador"
        case "flying":
            label?.textColor = .systemCyan  //OK
            return "Voador"
        case "poison":
            label?.textColor = UIColor(red: CGFloat(67)/CGFloat(255), green: CGFloat(26)/CGFloat(255), blue: CGFloat(68)/CGFloat(255), alpha: 1)    //OK
            return "Venenoso"
        case "ground":
            label?.textColor = UIColor(red: CGFloat(177)/CGFloat(255), green: CGFloat(77)/CGFloat(255), blue: CGFloat(44)/CGFloat(255), alpha: 1) //OK
            return "Terrestre"
        case "rock":
            label?.textColor = UIColor(red: CGFloat(255)/CGFloat(255), green: CGFloat(167)/CGFloat(255), blue: CGFloat(123)/CGFloat(255), alpha: 1) //OK
            return "Pedra"
        case "ghost":
            label?.textColor = UIColor(red: CGFloat(113)/CGFloat(255), green: CGFloat(103)/CGFloat(255), blue: CGFloat(131)/CGFloat(255), alpha: 1)  //OK
            return "Fantasma"
        case "steel":
            label?.textColor = UIColor(red: CGFloat(142)/CGFloat(255), green: CGFloat(142)/CGFloat(255), blue: CGFloat(142)/CGFloat(255), alpha: 1) //OK
            return "Metal"
        case "fire":
            label?.textColor = UIColor(red: CGFloat(182)/CGFloat(255), green: CGFloat(36)/CGFloat(255), blue: CGFloat(40)/CGFloat(255), alpha: 1)   //OK
            return "Fogo"
        case "grass":
            label?.textColor = UIColor(red: CGFloat(39)/CGFloat(255), green: CGFloat(145)/CGFloat(255), blue: CGFloat(55)/CGFloat(255), alpha: 1)   //OK
            return "Planta"
        case "electric":
            label?.textColor = UIColor(red: 255/255, green: 191/255, blue: 53/255, alpha: 1)    //OK
            return "Elétrico"
        case "psychic":
            label?.textColor = UIColor(red: CGFloat(176)/CGFloat(255), green: CGFloat(47)/CGFloat(255), blue: CGFloat(123)/CGFloat(255), alpha: 1)   //OK
            return "Psíquico"
        case "ice":
            label?.textColor = UIColor(red: CGFloat(125)/CGFloat(255), green: CGFloat(228)/CGFloat(255), blue: CGFloat(217)/CGFloat(255), alpha: 1)    //OK
            return "Gelo"
        case "dragon":
            label?.textColor = UIColor(red: CGFloat(0)/CGFloat(255), green: CGFloat(39)/CGFloat(255), blue: CGFloat(104)/CGFloat(255), alpha: 1)
            return "Dragão"
        case "dark":
            label?.textColor = .label
            return "Noturno"
        case "fairy":
            label?.textColor = UIColor(red: CGFloat(255)/CGFloat(255), green: CGFloat(165)/CGFloat(255), blue: CGFloat(232)/CGFloat(255), alpha: 1)
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
