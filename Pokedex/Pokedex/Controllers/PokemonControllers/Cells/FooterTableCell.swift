//
//  FooterTableCell.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 04/03/22.
//

import UIKit

protocol FooterTableCellDelegate{
    func didTap()
    
}

class FooterTableCell: UITableViewCell {

    @IBOutlet weak var loadMoreButton: UIButton!
    
    @IBOutlet weak var noMorePokemonLabel: UILabel!
    var delegate: FooterTableCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        loadMoreButton.layer.borderColor = UIColor.black.cgColor
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
  }
    
    @IBAction func didTapLoadMore(_ sender: UIButton) {
        delegate?.didTap()
    }
    
    
}
