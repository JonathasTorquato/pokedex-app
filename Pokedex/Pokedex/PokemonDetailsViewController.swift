//
//  PokemonDetailsViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 04/03/22.
//

import UIKit
import DropDown
import RxCocoa
import RxSwift


protocol PokemonDetailsViewControllerDelegate {
    func otherPokemon(to id: Int, viewController: PokemonDetailsViewController)
    func otherPokemon(to name: String, viewController: PokemonDetailsViewController)
    func pokemonVariation(other name: String, completion : @escaping(Int)->Void)
}

class PokemonDetailsViewController: UIViewController {

    @IBOutlet weak var type2Label: UILabel!
    @IBOutlet weak var type1label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var firstEvolution: UIButton!
    @IBOutlet weak var secondEvolutionTable: UITableView!
    @IBOutlet weak var thirdEvolutionTableView: UITableView!
    @IBOutlet weak var otherFormsTableView: UITableView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    let forms = BehaviorRelay<[Forms]>(value: [])
    let secondEvolutions: BehaviorRelay<[Chain]> = BehaviorRelay(value: [])
    let thirdEvolutions: BehaviorRelay<[Chain]> = BehaviorRelay(value: [])
    
    var id = 0
    var delegate: PokemonDetailsViewControllerDelegate?
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForms()
        setupEvolutions()
        setupTables()
        otherFormsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        secondEvolutionTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        thirdEvolutionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func setupTables() {
        
        self.secondEvolutionTable.rx.modelSelected(Chain.self).subscribe {[unowned self] pokemon in
            self.delegate?.otherPokemon(to: pokemon.element?.species?.name ?? "", viewController: self)
        }.disposed(by: bag)
        
        self.thirdEvolutionTableView.rx.modelSelected(Chain.self).subscribe {[unowned self] pokemon in
            self.delegate?.otherPokemon(to: pokemon.element?.species?.name ?? "", viewController: self)
        }.disposed(by: bag)
        
        self.otherFormsTableView.rx.modelSelected(Forms.self).subscribe(onNext:{ [unowned self] pokemonForm in
            self.delegate?.otherPokemon(to: pokemonForm.pokemon?.name ?? "", viewController: self)
        }).disposed(by: bag)
    }
    
    func setupForms() {
        forms.bind(to:otherFormsTableView.rx.items(cellIdentifier: "cell",  cellType: UITableViewCell.self)){row,form,cell in
            cell.textLabel?.text = form.pokemon?.name ?? "ERRO"
            cell.textLabel?.textAlignment = .center
            
        }.disposed(by: bag)
    }
    
    func setupEvolutions() {
        secondEvolutions.bind(to: secondEvolutionTable.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self))
        {row, evolution,cell in
            cell.textLabel?.text = "->\(evolution.species?.name ?? "ERRO")"
            cell.textLabel?.textAlignment = .center
            if let tEvolutions = evolution.evolves_to{
                let evolutions =  self.thirdEvolutions.value + tEvolutions
                self.thirdEvolutions.accept(evolutions)
            }
        }.disposed(by: bag)
        thirdEvolutions.bind(to: thirdEvolutionTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self))
        {row, evolution, cell  in
            cell.textLabel?.text = "->\(evolution.species?.name ?? "ERRO")"
            cell.textLabel?.textAlignment = .center
        }.disposed(by: bag)
        
    }
    fileprivate func setPokemonUI(pokemon: PokemonDTO){
        thirdEvolutions.accept([])
        DispatchQueue.main.async {
            self.leftButton.isEnabled = self.id > 1
            self.rightButton.isEnabled = self.id < 889
        }
        Network.getPokemonEntry(idPokemon: self.id) { result in
            switch result{
            case .success(let success):
                //MARK: - Evolutions
                if let chain = success.evolution_chain?.url{
                    Network.getPokemonChain(url: chain) { result in
                        switch result{
                        case .success(let success):
                            self.firstEvolution.setTitle(success.chain?.species?.name, for: .normal)
                            if let evolves_to = success.chain?.evolves_to{
                                self.secondEvolutions.accept(evolves_to)
                            }
                        case .failure(let error):
                            self.firstEvolution.setTitle("ERROR " + error.localizedDescription, for: .normal)
                        }
                    }
                }
                
                //MARK: - Entry
                DispatchQueue.main.async{
                    if let entry = success.flavor_text_entries {
                        var textEntry: String = ""
                        for flavor in entry
                        {
                            if let flavorText = flavor.flavor_text, flavor.language?.name == "en"
                            {
                                textEntry = flavorText
                            }
                        }
                        textEntry.removeAll { ch in
                            if ch == "\n"
                            {
                                return true
                            }
                            return false
                        }
                        self.descriptionLabel.text = textEntry
                    }
                    self.nameLabel.text = pokemon.name?.capitalizingFirstLetter()
                    self.title = "No. " + self.id.numberToSpecialNumber()
                    
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
                //MARK: -Varieties
                if let forms = success.varieties, forms.count > 0 {
                    self.forms.accept(forms)
                    
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        }
    }
    func setPokemon(pokemon: PokemonDTO){
        self.id = pokemon.id ?? 0
        if self.id >= 899 {
            self.delegate?.pokemonVariation(other: pokemon.species?.name ?? ""){ identifier in
                self.id = identifier
                DispatchQueue.main.async {
                    self.setPokemonUI(pokemon: pokemon)
                }
            }
        }
        else
        {
            setPokemonUI(pokemon: pokemon)
        }
    }
    
    @IBAction func didTapFirstStage(_ sender: UIButton) {
        self.delegate?.otherPokemon(to: sender.currentTitle ?? "", viewController: self)
    }
    @IBAction func didTapRight(_ sender: UIButton) {
        self.delegate?.otherPokemon(to: self.id + 1, viewController: self)
    }
    
    @IBAction func didTapLeft(_ sender: UIButton) {
        self.delegate?.otherPokemon(to: self.id - 1, viewController: self)
    }
}
