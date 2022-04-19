//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    @IBOutlet weak var activitView: UIActivityIndicatorView!
    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var type1Label: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    fileprivate var pokemon: PokemonDTO?
    
    fileprivate func setPokemon(_ pokemon: PokemonDTO)
    {
        self.pokemon = pokemon
        if let url = URL(string:  pokemon.sprites?.frontMale ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png"){
            
            GetImage.downloadImage(from: url, imageView: pokemonImageView)
        }
        nameLabel.text = pokemon.name?.capitalizingFirstLetter() ?? "Erro!"
        guard let number = pokemon.id?.numberToSpecialNumber() else {return}
        numberLabel.text = "No." + number
        
        type1Label.text = TypePortuguese.getTypePortuguese(name: pokemon.types?[0].type?.name ?? "Erro", type1Label)
        if pokemon.types?.count == 2
        {
            type2Label.text = TypePortuguese.getTypePortuguese(name: pokemon.types?[1].type?.name ?? "Erro", type2Label)
        }
        else
        {
            type2Label.text = ""
        }
        self.setActivityView(active: false)
    }
    
    fileprivate func setActivityView(active: Bool)
    {
        self.activitView.isHidden = !active
        self.activitView.startAnimating()
        if !active{
            self.activitView.stopAnimating()
        }
    }
    
    func setPokemon(_ id: Int)
    {
        setActivityView(active: true)
        Network.getPokemonID(id: id) { result in
            switch result{
                
            case .success(let pokemon):
                DispatchQueue.main.async {
                    self.setPokemon(pokemon)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setPokemon(_ name: String)
    {
        
    }
    
    func getPokemon()->PokemonDTO?{
        return self.pokemon
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
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
