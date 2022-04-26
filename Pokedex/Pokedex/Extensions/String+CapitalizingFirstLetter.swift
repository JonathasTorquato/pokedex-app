//
//  String+CapitalizingFirstLetter.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 26/04/22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

