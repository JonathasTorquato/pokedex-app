//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import UIKit

//MARK: - Declarations
class PokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var activitView: UIActivityIndicatorView!
    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var type1Label: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    fileprivate var pokemon: PokemonDTO?
}

//MARK: - Methods
extension PokemonTableViewCell {
    
    //MARK: - Pokemon Methods
    fileprivate func setPokemon(_ pokemon: PokemonDTO) {
        self.pokemon = pokemon
        if let url = URL(string:  pokemon.sprites.frontMale ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png"){
            
            GetImage.downloadImage(from: url, imageView: pokemonImageView)
        }
        nameLabel.text = pokemon.name.capitalizingFirstLetter().replacingOccurrences(of: "-", with: " ")
        numberLabel.text = "No." + pokemon.id.numberToSpecialNumber()
        
        type1Label.text = TypePortuguese.getTypePortuguese(name: pokemon.types[0].type.name, type1Label)
        if pokemon.types.count == 2
        {
            type2Label.text = TypePortuguese.getTypePortuguese(name: pokemon.types[1].type.name, type2Label)
        }
        else
        {
            type2Label.text = ""
        }
        self.setActivityView(active: false)
    }
        
    func setPokemon(_ id: Int) {
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
    
    func getPokemon()->PokemonDTO? {
        return self.pokemon
    }
    
    //MARK: - UI Actions
    fileprivate func setActivityView(active: Bool) {
        self.activitView.isHidden = !active
        self.activitView.startAnimating()
        if !active{
            self.activitView.stopAnimating()
        }
    }
    
}
