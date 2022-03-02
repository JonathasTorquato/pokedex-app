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
    
    fileprivate func setPokemon(_ pokemon: PokemonDTO)
    {
        GetImage.downloadImage(from: URL(fileReferenceLiteralResourceName:  pokemon.sprite?.first?.frontMale ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png"), imageView: pokemonImageView)
    }
    
    
    func setPokemon(_ id: Int)
    {
        Network.getPokemonID(id: id) { result in
            switch result{
                
            case .success(let pokemon):
                self.setPokemon(pokemon)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setPokemon(_ name: String)
    {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
