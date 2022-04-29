//
//  ViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import UIKit
import CloudKit
import RxSwift
import RxCocoa

//MARK: - Declarations
class ViewController: UIViewController {
    
    let bag = DisposeBag()
    let types : BehaviorRelay <[TypeURLDTO]> = BehaviorRelay(value: [])
    let pokemonsType : PublishRelay <[PokemonsByType]> = PublishRelay <[PokemonsByType]>()
    let viewModel : MainViewModel = MainViewModel()

    var numberOfCells = 0
    var size : Int = 0
    var range : Observable<Int> = Observable<Int>.range(start: 0, count: 0)
    var typeSelected : String = ""
    
    @IBOutlet weak var pokemonTypeTableView: UITableView!
    @IBOutlet weak var typesCollection: UICollectionView!
    @IBOutlet weak var tableView : UITableView!
}

//MARK: - Methods
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typesCollection.register(UINib(nibName: "TypeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "TypeCollectionCell")
        setupCollection()
        self.viewModel.getAllTypes { types in
            self.types.accept(types)
        }
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        range = .range(start: 0, count: numberOfCells)
        
        //typesCollection.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        tableView.register(UINib(nibName: "FooterTableCell", bundle: .main), forCellReuseIdentifier: "FooterCell")
        
        pokemonTypeTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        getCount()
    }
    
    fileprivate func setupCollection() {
        self.types.bind(to: self.typesCollection.rx.items(cellIdentifier: "TypeCollectionCell")){ row, type, cell in
            if let cell = cell as? TypeCollectionViewCell {
                cell.typeImageView.image = UIImage(named: type.name)
                
                cell.upperView.alpha = type.name == self.typeSelected ? 0.5 : 0
            }
        }.disposed(by: bag)
        self.typesCollection.rx.modelSelected(TypeURLDTO.self).subscribe { model in
            
            if self.typeSelected != model.element?.name {
                self.typeSelected = model.element!.name
                self.tableView.isHidden = true
                self.pokemonTypeTableView.isHidden = false
                self.viewModel.getPokemonsType(url: model.element?.url ?? "") { pokemons in
                    self.pokemonsType.accept(pokemons)
                }
            } else {
                self.typeSelected = ""
                self.tableView.isHidden = false
                self.pokemonTypeTableView.isHidden = true
            }
            self.types.accept(self.types.value)
        }.disposed(by: bag)
        self.pokemonsType.bind(to: pokemonTypeTableView.rx.items(cellIdentifier: "PokemonTableCell", cellType: PokemonTableViewCell.self)){ row, pokemon, cell in
            
            self.viewModel.getPokemonName(name: pokemon.pokemon.name) { pokemonDTO in
                cell.setPokemonDTO(pokemonDTO)
            }
            
        }.disposed(by: bag)
        
        self.pokemonTypeTableView.rx.modelSelected(PokemonsByType.self).subscribe { model in
            if let pokemon = model.element?.pokemon {
                self.showPokemonEntryName(name: pokemon.name)
            }
        }.disposed(by: bag)
    }
    
    func getCount() {
        viewModel.getPokemonCount { count in
            self.size = count
            self.numberOfCells = 15
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - Navigation
    func showPokemonEntry(id: Int, animated: Bool = true) {
        let vc = PokemonDetailsViewController()
        
        vc.navigationItem.rightBarButtonItem = {
            let button = UIBarButtonItem(title: "Shiny", style: .plain, target: vc, action: #selector(vc.toggleShiny))
            return button
        }()
        vc.delegate = self
        viewModel.getPokemonId(id: id) { pokemon in
            vc.setPokemon(pokemon: pokemon)
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    func showPokemonEntryName(name: String, animated: Bool = true) {
        let vc = PokemonDetailsViewController()
        
        vc.navigationItem.rightBarButtonItem = {
            let button = UIBarButtonItem(title: "Shiny", style: .plain, target: vc, action: #selector(vc.toggleShiny))
            return button
        }()
        vc.delegate = self
        viewModel.getPokemonName(name: name) { pokemon in
            vc.setPokemon(pokemon: pokemon)
            self.navigationController?.pushViewController(vc, animated: animated)
        }
    }

}

//MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < numberOfCells{
            showPokemonEntry(id: indexPath.row + 1)
        }
    }
}

//MARK: - TableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfCells{
            if let cell = cell as? FooterTableCell{
                if numberOfCells >= size{
                    cell.loadMoreButton.isHidden = true
                    cell.noMorePokemonLabel.isHidden = false
                }
                else
                {
                    cell.loadMoreButton.isHidden = false
                    cell.noMorePokemonLabel.isHidden = true
                    self.didTap()
                }
                
            }
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfCells > size{
            numberOfCells = size
        }
        return numberOfCells + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < numberOfCells {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableCell", for: indexPath) as! PokemonTableViewCell
            cell.setPokemon(indexPath.row + 1)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath) as! FooterTableCell
            cell.delegate = self
            
            return cell
        }
        
    }
    
}

//MARK: - FooterTableCellDelegate
extension ViewController: FooterTableCellDelegate {
    func didTap() {
        numberOfCells += 15
        tableView.reloadData()
    }
}

//MARK: - SearchBarDelegate
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text else {return}
        if search.first?.isLetter ?? false {
            self.viewModel.getPokemonName(name: search.lowercased()) { result in
                self.showPokemonEntry(id: result.id)
            }
        } else if let searched = (Int(search)), searched <= 898 && searched > 0 {
            self.viewModel.getPokemonId(id: searched) { result in
                self.showPokemonEntry(id: result.id)
            }
        }
    }
}

//MARK: - Extension PokemonDetailsViewControllerDelegate
extension ViewController : PokemonDetailsViewControllerDelegate {
    func pokemonVariation(other name: String, completion: @escaping (Int) -> Void) {
        viewModel.getPokemonName(name: name) { pokemon in
            completion(pokemon.id)
        }
    }
    
    func otherPokemon(to name: String, viewController: PokemonDetailsViewController) {
        if name != "" {
            viewModel.getPokemonName(name: name) { pokemon in
                viewController.setPokemon(pokemon: pokemon)
            }
        }
    }
    
    func otherPokemon(to id: Int, viewController : PokemonDetailsViewController) {
        if id != 0 {
            viewModel.getPokemonId(id: id) { pokemon in
                viewController.setPokemon(pokemon: pokemon)
            }
        }
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}
