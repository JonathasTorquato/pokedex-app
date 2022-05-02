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

    @IBOutlet weak var entriesTableView: UITableView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var femalePokemonButton: UIButton!
    @IBOutlet weak var malePokemonButton: UIButton!
    @IBOutlet weak var type2Label: UIButton!
    @IBOutlet weak var type1label: UIButton!
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
    let pokemon : PublishRelay<PokemonDTO> = PublishRelay<PokemonDTO>()
    let bag = DisposeBag()
    let shiny : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let gender : BehaviorRelay<PokemonGender> = BehaviorRelay(value: .none)
    let frontImage : BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let entryVersions : BehaviorRelay<[Entry]> = BehaviorRelay(value:[])
    let viewModel = PokemonDescriptionViewModel()
    
    var genderColor : BehaviorRelay<UIColor> = BehaviorRelay(value: .black)
    var id = 0
    var delegate: PokemonDetailsViewControllerDelegate?
}

//MARK: - Functions
extension PokemonDetailsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        if self.traitCollection.userInterfaceStyle == .dark {
            self.genderColor.accept(.white)
        }
        setPokemonUI()
        setupForms()
        setupEvolutions()
        setupTables()
        setupPokemonImage()
        setupPokemonGender()
        entriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        self.entryVersions.bind(to: self.entriesTableView.rx.items(cellIdentifier: "cell")){ row, entry,cell in
            cell.textLabel?.text = entry.version.name
            
        }.disposed(by: bag)
        
        self.entriesTableView.rx.modelSelected(Entry.self).subscribe{ model in
            var textEntry = model.element?.flavor_text ?? ""
            textEntry = textEntry.replacingOccurrences(of: "\n", with: " ")
            self.descriptionLabel.text = textEntry
        }.disposed(by: bag)
        
        
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
    
    fileprivate func setupPokemonImage() {
        
        Observable.combineLatest(self.shiny, self.gender, self.frontImage, self.pokemon)
            .subscribe(onNext:{ valueShiny, valueGender, valueFront, pokemon in
                if valueShiny{
                    if valueGender != .female {
                        if let image = valueFront ? pokemon.sprites.frontMaleShiny : pokemon.sprites.backMaleShiny, let imageURL = URL(string: image) {
                            
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Normal"
                            }
                        }
                    }
                    else {
                        if let image = valueFront ? pokemon.sprites.frontFemaleShiny : pokemon.sprites.backFemaleShiny, let imageURL = URL(string: image) {
                            
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Normal"
                            }
                        }
                    }
                }
                else {
                    if valueGender != .female{
                        if let image = valueFront ? pokemon.sprites.frontMale : pokemon.sprites.backMale, let imageURL = URL(string: image) {
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Shiny"
                            }
                        }
                    }
                    else {
                        if let image = valueFront ? pokemon.sprites.frontFemale : pokemon.sprites.backFemale, let imageURL = URL(string: image) {
                            DispatchQueue.main.async{
                                GetImage.downloadImage(from: imageURL, imageView: self.pokemonImage)
                                self.navigationItem.rightBarButtonItem?.title = "Shiny"
                            }
                        }
                    }
                }
            }).disposed(by: bag)
    }
    
    func setPokemonUI(){
        self.pokemon.subscribe(onNext:{ pokemon in
            self.thirdEvolutions.accept([])
            Network.getPokemonEntry(idPokemon: self.id) { result in
                switch result{
                case .success(let success):
                    //MARK: - Evolutions
                    if let chain = success.evolution_chain?.url{
                        Network.getPokemonChain(url: chain) { result in
                            DispatchQueue.main.async {
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
                    }
                    DispatchQueue.main.async {
                        self.leftButton.isEnabled = self.id > 1
                        self.rightButton.isEnabled = self.id <= 897
                    }
                    //MARK: - Entry
                    self.entryVersions.accept( self.viewModel.getAllEntries(pokemon: success))
                    DispatchQueue.main.async{
                        self.descriptionLabel.text = self.entryVersions.value.first?.flavor_text ?? ""
                        self.nameLabel.text = pokemon.name.capitalizingFirstLetter()
                        self.title = "No. " + self.id.numberToSpecialNumber()
                        
                        if let sprite = pokemon.sprites.frontMale, let url = URL(string: sprite){
                            self.imageButton.setTitle("", for: .normal)
                            self.imageButton.isEnabled = true
                            GetImage.downloadImage(from: url, imageView: self.pokemonImage)
                        }
                        else {
                            self.imageButton.setTitle("Nenhuma foto foi encontrada", for: .normal)
                            self.imageButton.isEnabled = false
                            self.pokemonImage.image = nil
                        }
                        self.type1label.setTitle(TypePortuguese.getTypePortuguese(name: pokemon.types[0].type.name, self.type1label.titleLabel), for: .normal)
                        self.type1label.setTitleColor(self.type1label.titleLabel?.textColor, for: .normal)
                        self.viewModel.urlType1 = pokemon.types[0].type
                        if pokemon.types.count == 2
                        {
                            self.type2Label.setTitle(TypePortuguese.getTypePortuguese(name: pokemon.types[1].type.name, self.type2Label.titleLabel), for: .normal)
                            self.type2Label.setTitleColor(self.type2Label.titleLabel?.textColor, for: .normal)
                            self.viewModel.urlType2 = pokemon.types[1].type
                        }
                        else
                        {
                            self.type2Label.setTitle("", for: .normal)
                            self.viewModel.urlType2 = nil
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
            guard let _ = pokemon.sprites.frontFemale else {
                self.gender.accept(.none)
                return
            }
            self.gender.accept(.male)
        }).disposed(by: bag)
    }
    
    func setPokemon(pokemon: PokemonDTO){
        self.id = pokemon.id
        self.shiny.accept(false)
        if self.id >= 899 {
            self.delegate?.pokemonVariation(other: pokemon.species.name){ identifier in
                self.id = identifier
                self.pokemon.accept(pokemon)
            }
        }
        else {
            DispatchQueue.main.async {
                self.pokemon.accept(pokemon)
            }
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
    
    @objc func toggleShiny() {
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
        
        sender.setImage(UIImage(systemName: self.viewModel.favoritePokemon(pokemonId: self.id) ? "heart.fill" : "heart"), for: .normal)
    }
    
    @IBAction func didTapType(_ sender : UIButton) {
        self.viewModel.typeURL(name: sender.currentTitle ?? "") { type in
            let vc = TypeDescriptionViewController()
            vc.tipo.accept(type)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
}

//MARK: - ENUM
enum PokemonGender {
    case male
    case female
    case none
}
