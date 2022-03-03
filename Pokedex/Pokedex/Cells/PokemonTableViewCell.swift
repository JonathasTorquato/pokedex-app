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
    
    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var type1Label: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    fileprivate func setPokemon(_ pokemon: PokemonDTO)
    {
        if let url = URL(string:  pokemon.sprites?.frontMale ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png"){
            
            GetImage.downloadImage(from: url, imageView: pokemonImageView)
        }
        nameLabel.text = pokemon.name?.capitalizingFirstLetter() ?? "Erro!"
        guard let number = pokemon.id?.numberToSpecialNumber() else {return}
        numberLabel.text = "No." + number
        
        type1Label.text = getTypePortuguese(name: pokemon.types?[0].type?.name ?? "Erro", type1Label)
        if pokemon.types?.count == 2
        {
            type2Label.text = getTypePortuguese(name: pokemon.types?[1].type?.name ?? "Erro", type2Label)
        }
        else
        {
            type2Label.text = ""
        }
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
    
    fileprivate func getTypePortuguese(name: String,_ label: UILabel?) -> String
    {
        switch name{
        case "bug":
            label?.backgroundColor = .systemGreen
            return "Inseto"
        case "water":
            return "Água"
        case "normal":
            return "Normal"
        case "fighting":
            return "Lutador"
        case "flying":
            return "Voador"
        case "poison":
            return "Venenoso"
        case "ground":
            return "Terrestre"
        case "rock":
            return "Pedra"
        case "ghost":
            return "Fantasma"
        case "steel":
            return "Metal"
        case "fire":
            return "Fogo"
        case "grass":
            return "Planta"
        case "electric":
            return "Elétrico"
        case "psychic":
            return "Psíquico"
        case "ice":
            return "Gelo"
        case "dragon":
            return "Dragão"
        case "dark":
            return "Noturno"
        case "fairy":
            return "Fada"
        case "unknown":
            return "Desconhecido"
        case "shadow":
            return "Sombra"
        default:
            return "Erro"
        }
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
        else
        {
            return "00\(self)"
        }
    }
}
