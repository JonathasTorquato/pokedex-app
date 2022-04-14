//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 04/03/22.
//

import UIKit
import DropDown
class PokemonDetailsViewController: UIViewController {

    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var type1label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondEvolutionLabel: UILabel!
    @IBOutlet weak var secondThirdLabel: UILabel!
    
    @IBOutlet weak var eigthSecondLabel: UILabel!
    @IBOutlet weak var seventhSecondLabel: UILabel!
    @IBOutlet weak var sixthSecondLabel: UILabel!
    @IBOutlet weak var forthSecondLabel: UILabel!
    @IBOutlet weak var thirdSecondLabel: UILabel!
    @IBOutlet weak var secondSecondEvolution: UILabel!
    @IBOutlet weak var thirdEvolutionLabel: UILabel!
    @IBOutlet weak var firstEvolutionLabel: UILabel!
    @IBOutlet weak var fifthSecondLabel: UILabel!
    var secondLabels : [UILabel] = []
    var thirdLabels : [UILabel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        thirdLabels = [thirdEvolutionLabel, secondThirdLabel]
        secondLabels = [secondEvolutionLabel, secondSecondEvolution, thirdSecondLabel, forthSecondLabel, fifthSecondLabel,sixthSecondLabel,seventhSecondLabel,eigthSecondLabel]
    }
    
    func setPokemon(pokemon: PokemonDTO){
        Network.getPokemonEntry(idPokemon: pokemon.id ?? 0) { result in
            switch result{
            case .success(let success):
                if let chain = success.evolution_chain?.url{
                    Network.getPokemonChain(url: chain) { result in
                        switch result{
                        case .success(let response):
                            DispatchQueue.main.async {
                                self.firstEvolutionLabel.text = response.chain?.species?.name
                                if let second = response.chain?.evolves_to
                                {
                                    var count : Int = 0
                                    for evo in second{
                                        self.secondLabels[count].text = "-> " + (evo.species?.name ?? "")
                                        if  evo.evolves_to?.count ?? 0 > count{
                                            if let third = evo.evolves_to, let thirdName = third[count].species?.name
                                            {
                                                self.thirdLabels[count].text = "-> " + thirdName
                                            }
                                        }
                                        count += 1
                                    }
                                    if count < (second.first?.evolves_to?.count ?? 0)
                                    {
                                        count = 0
                                        if let third = second.first?.evolves_to{
                                            for evo in third
                                            {
                                                if let thirdName = evo.species?.name{
                                                    self.thirdLabels[count].text = "-> " + thirdName
                                                }
                                                count += 1
                                            }
                                        }
                                    }
                                }
                                
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                DispatchQueue.main.async{
                    if let entry = success.flavor_text_entries {
                        for flavor in entry
                        {
                            if flavor.language?.name == "en"
                            {
                                self.descriptionLabel.text = flavor.flavor_text
                            }
                        }
                        
                    }
                    
                    
                    self.nameLabel.text = pokemon.name?.capitalizingFirstLetter()
                    guard let number = pokemon.id?.numberToSpecialNumber() else {return}
                    self.title = "No. " + number
                    
                    if let url = URL(string:  pokemon.sprites?.frontMale ?? "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/2.png"){
                        
                        GetImage.downloadImage(from: url, imageView: self.pokemonImage)
                    }
                    
                    self.type1label.text = TypePortuguese.getTypePortuguese(name: pokemon.types?[0].type?.name ?? "Erro", self.type1label)
                    if pokemon.types?.count == 2
                    {
                        self.type2Label.text = TypePortuguese.getTypePortuguese(name: pokemon.types?[1].type?.name ?? "Erro", self.type2Label)
                    }
                    else
                    {
                        self.type2Label.text = ""
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        }
        
    }
    
    
}
