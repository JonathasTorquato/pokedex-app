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
    
    
    
}
