//
//  FooterTableCell.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 04/03/22.
//

import UIKit

//MARK: - Delegate
protocol FooterTableCellDelegate{
    func didTap()
    
}

//MARK: - Declarations
class FooterTableCell: UITableViewCell {
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var noMorePokemonLabel: UILabel!
    var delegate: FooterTableCellDelegate?
}

//MARK: - Methods
extension FooterTableCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    //MARK: - SETUP
    fileprivate func setupButton(){
        loadMoreButton.layer.borderColor = UIColor.black.cgColor
        loadMoreButton.layer.borderWidth = 1
        loadMoreButton.layer.cornerRadius = 10
    }
    
    //MARK: - Actions
    @IBAction func didTapLoadMore(_ sender: UIButton) {
        delegate?.didTap()
    }
    
    
}
