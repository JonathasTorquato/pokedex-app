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
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    let viewModel = AllItemsViewModel()
    let bag = DisposeBag()
    let total:PublishSubject<Int> = PublishSubject()
    
    var totalItems : Int = 20
    var itemLimit : Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let itemDescriptionVC = ItemDescriptionViewController()
        itemDescriptionVC.modalTransitionStyle = .partialCurl
        item.name = item.name.capitalizingFirstLetter().replacingOccurrences(of: "-", with: " ")
        self.navigationController?.pushViewController(itemDescriptionVC, animated: true)
        DispatchQueue.main.async{
            itemDescriptionVC.item.accept(item)
        }
    }
    @IBAction func didTapSurpriseButton(_ sender: Any) {
        let itemRand = Int.random(in: 1...1000)
        self.viewModel.getItemId(id: itemRand) { item in
            self.presentItemDescription(item: item)
        }
        
    }
    
}
//MARK: - TableView Delegate e Data source
extension ListAllItemsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalItems <= itemLimit {
            itemLimit = totalItems
        }
        return itemLimit + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == itemLimit {
            itemLimit += 20
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < itemLimit {
            
            if let cell = tableView.cellForRow(at: indexPath) as? ItemsCell, let item = cell.itemValue {
                self.presentItemDescription(item: item)
            }
            
            
        }
    }
    
    
    
}

extension ListAllItemsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text, search != "" {
            self.viewModel.getItemName(name: search, completionSuc: {item in
                self.presentItemDescription(item: item)
            }, completionError: { erro in
                let alert = UIAlertController(title: "Item não encontrado", message: erro, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
        }
        self.view.endEditing(true)
    }
}
