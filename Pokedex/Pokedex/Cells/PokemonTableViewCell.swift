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
    
    func getPokemon()->PokemonDTO?{
        return self.pokemon
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    fileprivate func getTypePortuguese(name: String,_ label: UILabel?) -> String
    {
        switch name{
        case "bug":
            label?.textColor = .systemGreen
            return "Inseto"
        case "water":
            label?.textColor = .systemBlue
            return "Água"
        case "normal":
            label?.textColor = .systemGray
            return "Normal"
        case "fighting":
            label?.textColor = .red
            return "Lutador"
        case "flying":
            label?.textColor = .systemCyan
            return "Voador"
        case "poison":
            label?.textColor = .systemPurple
            return "Venenoso"
        case "ground":
            label?.textColor = .systemBrown
            return "Terrestre"
        case "rock":
            label?.textColor = .systemGray2
            return "Pedra"
        case "ghost":
            label?.textColor = .purple
            return "Fantasma"
        case "steel":
            label?.textColor = .blue
            return "Metal"
        case "fire":
            label?.textColor = .systemRed
            return "Fogo"
        case "grass":
            label?.textColor = .green
            return "Planta"
        case "electric":
            label?.textColor = .yellow
            return "Elétrico"
        case "psychic":
            label?.textColor = .magenta
            return "Psíquico"
        case "ice":
            label?.textColor = .cyan
            return "Gelo"
        case "dragon":
            label?.textColor = .orange
            return "Dragão"
        case "dark":
            label?.textColor = .systemTeal
            return "Noturno"
        case "fairy":
            label?.textColor = .systemPink
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
