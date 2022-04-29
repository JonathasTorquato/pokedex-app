//
//  TypeCollectionViewCell.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 29/04/22.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var upperView: UIView!
    var index : Int = 0
    
    @IBOutlet weak var typeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
