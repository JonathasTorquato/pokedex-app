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
    @IBOutlet weak var tableView: UITableView!
    
    let bag = DisposeBag()
    let viewModel = FavoritesViewModel()
}

//MARK: - Methods

extension FavoritesTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        
        setupTable()
    }
    
    //MARK: - Rx Setup
    fileprivate func setupTable() {
        
        Favorites.favoritePokemon.bind(to: self.tableView.rx.items(cellIdentifier: "PokemonTableCell")) { row,pokemonId,cell in
            if let cell = cell as? PokemonTableViewCell{
                cell.setPokemon(pokemonId)
            }
        }.disposed(by: bag)
        self.tableView.rx.modelSelected(Int.self).subscribe(onNext: { [unowned self] value in
            self.showPokemonEntry(id: value)
            
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
