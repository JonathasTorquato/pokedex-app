//
//  ListAllItemsViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 25/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class ListAllItemsViewController: UIViewController {
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var itemsTableView: ItemTableView!
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    let viewModel = AllItemsViewModel()
    let bag = DisposeBag()
    let total:PublishSubject<Int> = PublishSubject()
    var filteredItems : [GenericURLDTO] = []
    var originalFilteredItems : [GenericURLDTO] = []
    
    var totalItems : Int = 20
    var itemLimit : Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryButton.layer.cornerRadius = 10
        self.categoryButton.clipsToBounds = true
        
        self.itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.itemsTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "category")
        self.itemsTableView.register(UINib(nibName: "ItemsCell", bundle: .main), forCellReuseIdentifier: "ItemCell")
        setupTable()
        subscribeLimit()
        getLimit()
        itemSearchBar.delegate = self
        
    }
    
    func subscribeLimit() {
        total.subscribe(onNext: { value in
            self.totalItems = value
            self.itemsTableView.reloadData()
        }).disposed(by: bag)
    }
    
    func getLimit(){
        viewModel.getItems { count in
            self.total.onNext(count.count)
        }
    }
    
    func setupTable() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    func presentItemDescription(item : ItemDTO) {
        let itemDescriptionVC = ItemDescriptionViewController(item : item)
        itemDescriptionVC.modalTransitionStyle = .partialCurl
        item.name = item.name.capitalizingFirstLetter().replacingOccurrences(of: "-", with: " ")
        self.navigationController?.pushViewController(itemDescriptionVC, animated: true)
    }
    @IBAction func didTapSurpriseButton(_ sender: Any) {
        let itemRand = Int.random(in: 1...1000)
        self.viewModel.getItemId(id: itemRand) { item in
            self.presentItemDescription(item: item)
        }
        
    }
    
    @IBAction func didTapCategoryButton(_ sender: UIButton) {
        
        if self.itemsTableView.tableType == .normal{
            self.itemsTableView.tableType = .menu
        }
        else {
            sender.setTitle("Selecionar Categoria", for: .normal)
            self.itemsTableView.tableType = .normal
        }
        self.itemsTableView.reloadData()
        
    }
}
//MARK: - TableView Delegate e Data source
extension ListAllItemsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableView = tableView as? ItemTableView {
            switch tableView.tableType {
                
            case .normal:
                if totalItems <= itemLimit {
                    itemLimit = totalItems
                }
                return itemLimit + 1
            case .menu:
                return 50
            case .filtered:
                return filteredItems.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableView = tableView as? ItemTableView else {
            return UITableViewCell()
        }
        switch tableView.tableType {
        case .normal:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemsCell{
                if indexPath.row < itemLimit {
                    self.viewModel.getItemId(id: indexPath.row + 1) { item in
                        item.name = item.name.replacingOccurrences(of: "-", with: " ")
                        item.name.capitalizeFirstLetter()
                        cell.item.accept(item)
                    }
                }
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "Todos os Items foram listados"
                return cell
            }
        case .menu:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "category") as? CategoryTableViewCell else {
                return UITableViewCell()
            }
            self.viewModel.getItemCategoryId(id: indexPath.row + 1, completionSuc: { category in
                cell.category = category
                cell.textLabel?.text = category.name
            }, completionError: { erro in
                cell.textLabel?.text = erro
            })
            return cell
        case .filtered:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemsCell {
                self.viewModel.getItemName(name: self.filteredItems[indexPath.row].name.lowercased().replacingOccurrences(of: " ", with: "-"), completionSuc: { item in
                    item.name = item.name.replacingOccurrences(of: "-", with: " ")
                    item.name.capitalizeFirstLetter()
                    cell.item.accept(item)
                    cell.textLabel?.text = ""
                }, completionError: {error in
                    cell.textLabel?.text = error
                    
                })
                return cell
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == itemLimit {
            itemLimit += 20
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? ItemTableView else {return}
        switch tableView.tableType {
        case .normal :
            if indexPath.row < itemLimit {
            
                if let cell = tableView.cellForRow(at: indexPath) as? ItemsCell, let item = cell.itemValue {
                    self.presentItemDescription(item: item)
                }
                
                
            }
        case .menu :
            if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell, let category = cell.category {
                tableView.tableType = .filtered
                self.categoryButton.setTitle(category.name + "  X", for: .normal)
                self.filteredItems = category.items
                self.originalFilteredItems = category.items
                tableView.reloadData()
            }
        case .filtered:
            if let cell = tableView.cellForRow(at: indexPath) as? ItemsCell, let item = cell.itemValue {
                self.presentItemDescription(item: item)
            }
        }
    }
    
    
    
}

extension ListAllItemsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text, search != "", self.itemsTableView.tableType != .filtered {
            self.viewModel.getItemName(name: search, completionSuc: {item in
                self.presentItemDescription(item: item)
            }, completionError: { erro in
                let alert = UIAlertController(title: "Item não encontrado", message: erro, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
        } else if let search = searchBar.text, self.itemsTableView.tableType == .filtered {
            self.filteredItems = self.viewModel.searchFilteredItems(search: search, filtered: self.originalFilteredItems)
            self.itemsTableView.reloadData()
        }
        self.view.endEditing(true)
    }
}


class ItemTableView : UITableView {
    enum TableViewType {
        case normal
        case menu
        case filtered
    }
    var tableType : TableViewType = .normal
}

class CategoryTableViewCell : UITableViewCell {
    var category : ItemCategory?
}
