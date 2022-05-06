//
//  FavoritesTableViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 22/04/22.
//

import UIKit
import RxSwift
import RxCocoa

//MARK: - Declarations
class FavoritesTableViewController: UIViewController {
    @IBOutlet weak var favoritesSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let bag = DisposeBag()
    let pokemon : BehaviorRelay <[PokemonDTO]> = BehaviorRelay(value : [])
    let originalPokemon : BehaviorRelay <[PokemonDTO]> = BehaviorRelay(value : [])
    let viewModel = FavoritesViewModel()
}

//MARK: - Methods

extension FavoritesTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesSearchBar.delegate = self
        self.tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - Rx Setup
    fileprivate func setupTable() {
        Favorites.favoritePokemon.subscribe(onNext: {value in
            self.originalPokemon.accept([])
            for id in value {
                self.viewModel.getPokemonId(id: id) { pokemon in
                    var listPokemon = self.pokemon.value
                    listPokemon.append(pokemon)
                    listPokemon.sort { p1, p2 in
                        return p1.id <= p2.id
                    }
                    self.originalPokemon.accept(listPokemon)
                }
            }
        }).disposed(by: bag)
        
        self.originalPokemon.subscribe(onNext: { value in
            var sortedValue = value
            sortedValue.sort { p1, p2 in
                if p1.id <= p2.id
                {
                    return true
                }
                return false
            }
            self.pokemon.accept(value)
        }).disposed(by: bag)
        
        pokemon.bind(to: self.tableView.rx.items(cellIdentifier: "PokemonTableCell")) { row,pokemon,cell in
            if let cell = cell as? PokemonTableViewCell {
                cell.setPokemonDTO(pokemon)
            }
        }.disposed(by: bag)
        self.tableView.rx.modelSelected(PokemonDTO.self).subscribe(onNext: { [unowned self] value in
            self.showPokemonEntry(id: value.id)
            
        }).disposed(by: bag)
    }
    
    //MARK: - Navigation
    func showPokemonEntry(id: Int, animated: Bool = true) {
        let vc = PokemonDetailsViewController()
        //MARK: - New View Controller NavBarButton Definition
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

}

//MARK: -PokemonDetailsDelegate Extension
extension FavoritesTableViewController : PokemonDetailsViewControllerDelegate {
    
    func pokemonVariation(other name: String, otherId : String, completion: @escaping (Int) -> Void) {
        viewModel.getPokemonName(name: name, otherId: otherId) { pokemon in
            completion(pokemon.id)
        }
    }
    
    func otherPokemon(to name: String, otherId: String, viewController: PokemonDetailsViewController) {
        if name != "" {
            viewModel.getPokemonName(name: name, otherId: otherId) { pokemon in
                viewController.setPokemon(pokemon: pokemon)
            }
        }
    }
    
    func otherPokemon(to id: Int, viewController : PokemonDetailsViewController) {
        let list = Favorites.favoritePokemon.value
        if let index = list.firstIndex(of: viewController.id){
            if id < viewController.id && index > 0{
                viewModel.getPokemonId(id: list[index - 1]) { pokemon in
                    viewController.setPokemon(pokemon: pokemon)
                }
            }
            else if id > viewController.id && index < list.count - 1{
                viewModel.getPokemonId(id: list[index + 1]) { pokemon in
                    viewController.setPokemon(pokemon: pokemon)
                }
            }
        } else if list.count > 0{
            viewModel.getPokemonId(id: list[0]) { pokemon in
                viewController.setPokemon(pokemon: pokemon)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
}

extension FavoritesTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text{
            self.pokemon.accept(self.viewModel.searchPokemon(search: search, from: self.originalPokemon.value))
        }
        self.view.endEditing(true)
    }
}
