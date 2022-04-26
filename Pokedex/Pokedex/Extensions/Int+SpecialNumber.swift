//
//  Int+SpecialNumber.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 26/04/22.
//

import Foundation

extension Int{
    func numberToSpecialNumber() -> String
    {
        if(self >= 100)
        {
            return "\(self)"
        }
        else if (self >= 10)
        {
            return "0\(self)"
        }
        else if self > 0
        {
            return "00\(self)"
        }
        else
        {
            return "invalid number"
        }
    }
}
