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

//MARK: - Delegate
protocol PokemonDetailsViewControllerDelegate {
    func otherPokemon(to id: Int, viewController: PokemonDetailsViewController)
    func otherPokemon(to name: String, viewController: PokemonDetailsViewController)
    func pokemonVariation(other name: String, completion : @escaping(Int)->Void)
}

//MARK: - Declarations
class PokemonDetailsViewController: UIViewController {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var femalePokemonButton: UIButton!
    @IBOutlet weak var malePokemonButton: UIButton!
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
    let bag = DisposeBag()
    let shiny : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let gender : BehaviorRelay<PokemonGender> = BehaviorRelay(value: .none)
    let frontImage : BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let viewModel = PokemonDescriptionViewModel()
    
    var genderColor : BehaviorRelay<UIColor> = BehaviorRelay(value: .black)
    var pokemon : PokemonDTO?
    var id = 0
    var delegate: PokemonDetailsViewControllerDelegate?
    
}

//MARK: - Functions
extension PokemonDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.userInterfaceStyle == .dark {
            self.genderColor.accept(.white)
        }
        setupForms()
        setupEvolutions()
        setupTables()
        setupPokemonImage()
        setupPokemonGender()
        
        otherFormsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        secondEvolutionTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        thirdEvolutionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.malePokemonButton.layer.borderWidth = 1
        self.femalePokemonButton.layer.borderWidth = 1
    }
    
    fileprivate func setupPokemonGender() {
        Observable.combineLatest(self.gender, self.genderColor).subscribe(onNext:{ value, valueColor in
            let none = value == .none
            let otherColor = valueColor == .black ? UIColor.white : UIColor.black
            self.malePokemonButton.isEnabled = !none
            self.femalePokemonButton.isEnabled = !none
            if !none {
                if value == .male {
                    self.malePokemonButton.layer.borderColor = valueColor.cgColor
                    self.femalePokemonButton.layer.borderColor = otherColor.cgColor
                }
                else {
                    self.malePokemonButton.layer.borderColor = otherColor.cgColor
                    self.femalePokemonButton.layer.borderColor = valueColor.cgColor
                }
            }
            else {
                self.malePokemonButton.layer.borderColor = otherColor.cgColor
                self.femalePokemonButton.layer.borderColor = otherColor.cgColor
            }

        }).disposed(by: bag)
    }
    //MARK: - Setup table views
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
    
    fileprivate func setupPokemonImage(){
        
        Observable.combineLatest(self.shiny, self.gender, self.frontImage)
            .subscribe(onNext:{ valueShiny, valueGender, valueFront in
                if valueShiny{
                    if valueGender != .female {
                        if let image = valueFront ? self.pokemon?.sprites?.frontMaleShiny : self.pokemon?.sprites?.backMaleShiny, let imageURL = URL(string: image) {
                            
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Normal"
                            }
                        }
                    }
                    else {
                        if let image = valueFront ? self.pokemon?.sprites?.frontFemaleShiny : self.pokemon?.sprites?.backFemaleShiny, let imageURL = URL(string: image) {
                            
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Normal"
                            }
                        }
                    }
                }
                else {
                    if valueGender != .female{
                        if let image = valueFront ? self.pokemon?.sprites?.frontMale : self.pokemon?.sprites?.backMale, let imageURL = URL(string: image) {
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Shiny"
                            }
                        }
                    }
                    else {
                        if let image = valueFront ? self.pokemon?.sprites?.frontFemale : self.pokemon?.sprites?.backFemale, let imageURL = URL(string: image) {
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Shiny"
                            }
                        }
                    }
                }
            }).disposed(by: bag)
    }
    
    fileprivate func setPokemonUI(pokemon: PokemonDTO){
        thirdEvolutions.accept([])
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
                DispatchQueue.main.async {
                    self.leftButton.isEnabled = self.id > 1
                    self.rightButton.isEnabled = self.id <= 897
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
                        textEntry = textEntry.replacingOccurrences(of: "\n", with: " ")
                        /*textEntry.removeAll { ch in
                            if ch == "\n"
                            {
                                return true
                            }
                            return false
                        }*/
                        self.descriptionLabel.text = textEntry
                    }
                    self.nameLabel.text = pokemon.name?.capitalizingFirstLetter()
                    self.title = "No. " + self.id.numberToSpecialNumber()
                    
                    if let sprite = pokemon.sprites?.frontMale, let url = URL(string: sprite){
                        self.imageButton.setTitle("", for: .normal)
                        self.imageButton.isEnabled = true
                        GetImage.downloadImage(from: url, imageView: self.pokemonImage)
                    }
                    else {
                        self.imageButton.setTitle("Nenhuma foto foi encontrada", for: .normal)
                        self.imageButton.isEnabled = false
                        self.pokemonImage.image = nil
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
                //MARK: - Varieties
                if let forms = success.varieties, forms.count > 0 {
                    self.forms.accept(forms)
                    
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            
        }
        DispatchQueue.main.async {
            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            for id in Favorites.favoritePokemon.value {
                if id == self.id {
                    self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            }
        }
        
        self.frontImage.accept(true)
        
        //MARK: - SETUP GENDER
        guard let _ = pokemon.sprites?.frontFemale else {
            self.gender.accept(.none)
            return
        }
        self.gender.accept(.male)
        
    }
    func setPokemon(pokemon: PokemonDTO){
        self.id = pokemon.id ?? 0
        self.shiny.accept(false)
        if self.id >= 899 {
            self.delegate?.pokemonVariation(other: pokemon.species?.name ?? ""){ identifier in
                self.id = identifier
                self.pokemon = pokemon
                DispatchQueue.main.async {
                    self.setPokemonUI(pokemon: pokemon)
                }
            }
        }
        else
        {
            self.pokemon = pokemon
            setPokemonUI(pokemon: pokemon)
        }
    }
    
    //MARK: - Status bar color
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.genderColor.accept(self.genderColor.value == .black ? .white : .black )
    }
    
    //MARK: - Actions
    
    @IBAction func didTapFirstStage(_ sender: UIButton) {
        self.delegate?.otherPokemon(to: sender.currentTitle ?? "", viewController: self)
    }
    @IBAction func didTapRight(_ sender: UIButton) {
        self.delegate?.otherPokemon(to: self.id + 1, viewController: self)
    }
    
    @IBAction func didTapLeft(_ sender: UIButton) {
        self.delegate?.otherPokemon(to: self.id - 1, viewController: self)
    }
    
    @objc func toggleShiny(){
        self.shiny.accept(!self.shiny.value)
    }
    @IBAction func didTapFemale(_ sender: UIButton) {
        self.gender.accept(.female)
    }
    
    @IBAction func didTapImage(_ sender: UIButton) {
        self.frontImage.accept(!self.frontImage.value)
    }
    
    @IBAction func didTapMale(_ sender: UIButton) {
        self.gender.accept(.male)
    }
    
    @IBAction func didTapHeart(_ sender: UIButton) {
        if self.id == 0 {return}
        var favorites = Favorites.favoritePokemon.value
        var added = false
        for id in favorites {
            if id == self.id {
                added = true
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
                favorites.removeAll { ids in
                    if ids == id {
                        return true
                    }
                    return false
                }
            }
        }
        if !added {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favorites.append(self.id)
        }
        favorites.sort()
        
        self.viewModel.saveUserDefatuls(value: favorites, for: Favorites.favoritePokemonKey)
        Favorites.favoritePokemon.accept(favorites)
    }
}

//MARK: - ENUM
enum PokemonGender {
    case male
    case female
    case none
}