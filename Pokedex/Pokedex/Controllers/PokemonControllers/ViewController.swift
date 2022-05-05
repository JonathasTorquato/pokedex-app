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
    let types : BehaviorRelay <[GenericURLDTO]> = BehaviorRelay(value: [])
    let pokemonsType : PublishRelay <[PokemonsByType]> = PublishRelay <[PokemonsByType]>()
    let viewModel : MainViewModel = MainViewModel()
    let pokemonSearch : PublishRelay<String> = PublishRelay<String>()

    var pokemonTypeOriginal : BehaviorRelay<[PokemonsByType]> = BehaviorRelay(value:[])
    var numberOfCells = 0
    var size : Int = 0
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        tableView.register(UINib(nibName: "FooterTableCell", bundle: .main), forCellReuseIdentifier: "FooterCell")
        
        pokemonTypeTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        getCount()
        setupSearch()
    }
    
    fileprivate func setupCollection() {
        self.types.bind(to: self.typesCollection.rx.items(cellIdentifier: "TypeCollectionCell")){ row, type, cell in
            if let cell = cell as? TypeCollectionViewCell {
                cell.typeImageView.image = UIImage(named: type.name)
                
                cell.upperView.alpha = type.name == self.typeSelected ? 0.5 : 0
            }
        }.disposed(by: bag)
        self.typesCollection.rx.modelSelected(GenericURLDTO.self).subscribe { model in
            
            if self.typeSelected != model.element?.name {
                self.typeSelected = model.element!.name
                self.tableView.isHidden = true
                self.pokemonTypeTableView.isHidden = false
                self.viewModel.getPokemonsType(url: model.element?.url ?? "") { pokemons in
                    self.pokemonsType.accept(pokemons)
                    self.pokemonTypeOriginal.accept(pokemons)
                }
            } else {
                self.typeSelected = ""
                self.tableView.isHidden = false
                self.pokemonTypeTableView.isHidden = true
                self.pokemonsType.accept([])
                self.pokemonTypeOriginal.accept([])
            }
            self.types.accept(self.types.value)
        }.disposed(by: bag)
        self.pokemonsType.bind(to: pokemonTypeTableView.rx.items(cellIdentifier: "PokemonTableCell", cellType: PokemonTableViewCell.self)){ row, pokemon, cell in
            
            self.viewModel.getPokemonName(name: pokemon.pokemon.name, completionSuc: { pokemonDTO in
                cell.setPokemonDTO(pokemonDTO)
            }, completionError: { erro in
                self.presentAction(message: erro)
            })
            
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
    
    fileprivate func setupSearch() {
        Observable.combineLatest(self.pokemonSearch, self.pokemonTypeOriginal).subscribe(onNext:{ value, pokemons in
            if value == ""{
                self.pokemonsType.accept(pokemons)
            } else {
                var newList : [PokemonsByType] = []
                if value.first?.isLetter ?? false {
                    for pokemon in pokemons {
                        if pokemon.pokemon.name.contains(value.lowercased().replacingOccurrences(of: " ", with: "-")) {
                            newList.append(pokemon)
                        }
                    }
                } else if value.first?.isNumber ?? false {
                    for pokemon in pokemons {
                        if ("\(pokemon.pokemon.url )").contains(value.lowercased()) {
                            newList.append(pokemon)
                        }
                    }
                } else {
                    newList = self.pokemonTypeOriginal.value
                }
                self.pokemonsType.accept(newList)
                
            }
            
        }).disposed(by: bag)
    }
    
    //MARK: - Navigation
    func showPokemonEntry(id: Int, animated: Bool = true) {
        let vc = PokemonDetailsViewController()
        vc.navigationItem.rightBarButtonItem = {
            let button = UIBarButtonItem(title: "Shiny", style: .plain, target: vc, action: #selector(vc.toggleShiny))
            return button
        }()
        vc.delegate = self
        viewModel.getPokemonId(id: id,completionSuc: { pokemon in
            self.navigationController?.pushViewController(vc, animated: animated)
            vc.setPokemonUI()
            vc.setPokemon(pokemon: pokemon)
        },completionError: { erro in
            self.presentAction(message: erro)
        })
    }
    
    func showPokemonEntryName(name: String, animated: Bool = true) {
        let vc = PokemonDetailsViewController()
        vc.navigationItem.rightBarButtonItem = {
            let button = UIBarButtonItem(title: "Shiny", style: .plain, target: vc, action: #selector(vc.toggleShiny))
            return button
        }()
        vc.delegate = self
        viewModel.getPokemonName(name: name, completionSuc: { pokemon in
            self.navigationController?.pushViewController(vc, animated: animated)
            vc.setPokemonUI()
            vc.setPokemon(pokemon: pokemon)
        },completionError: { erro in
            self.presentAction(message: erro)
        })
    }

    func presentAction(message : String) {
        let alert = UIAlertController(title: "Erro de servidor", message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertButton)
        self.present(alert, animated: true, completion: nil)
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
        if self.typeSelected == "" {
            if search.first?.isLetter ?? false {
                self.viewModel.getPokemonName(name: search.lowercased().replacingOccurrences(of: " ", with: "-"),completionSuc: { result in
                    self.showPokemonEntry(id: result.id)
                }, completionError: { erro in
                    self.presentAction(message: erro)
                })
            } else if let searched = (Int(search)), searched <= 898 && searched > 0 {
                self.viewModel.getPokemonId(id: searched, completionSuc: { result in
                    self.showPokemonEntry(id: result.id)
                }, completionError: { erro in
                    self.presentAction(message: erro)
                })
            }
        } else {
            self.pokemonSearch.accept(search)
        }
        view.endEditing(true)
    }
}

//MARK: - Extension PokemonDetailsViewControllerDelegate
extension ViewController : PokemonDetailsViewControllerDelegate {
    func pokemonVariation(other name: String, completion: @escaping (Int) -> Void) {
        viewModel.getPokemonName(name: name,completionSuc: { pokemon in
            completion(pokemon.id)
        }, completionError: { erro in
            self.presentAction(message: erro)
        })
    }
    
    func otherPokemon(to name: String, viewController: PokemonDetailsViewController) {
        if name != "" {
            viewModel.getPokemonName(name: name,completionSuc: { pokemon in
                viewController.setPokemon(pokemon: pokemon)
            },completionError : { erro in
                self.presentAction(message: erro)
            })
        }
    }
    
    func otherPokemon(to id: Int, viewController : PokemonDetailsViewController) {
        if id != 0 {
            viewModel.getPokemonId(id: id, completionSuc: { pokemon in
                viewController.setPokemon(pokemon: pokemon)
            }, completionError: { erro in
                self.presentAction(message: erro)
            })
        }
    }
}
