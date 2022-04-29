//
//  AllTypesViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 28/04/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AllTypesViewController : UIViewController {
    
    let viewModel = AllTypesViewModel()
    let bag = DisposeBag()
    let types : BehaviorRelay<[TypeURLDTO]> = BehaviorRelay(value: [])
    
    @IBOutlet weak var typesTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupTable()
        self.viewModel.getTypes { types in
            self.types.accept(types)
        }
    }
    
    fileprivate func setupTable() {
        self.types.bind(to: typesTableView.rx.items(cellIdentifier: "cell")) { row, type, cell in
            cell.textLabel?.text = TypePortuguese.getTypePortuguese(name: type.name, cell.textLabel)
            
        }.disposed(by: bag)
        self.typesTableView.rx.modelSelected(TypeURLDTO.self).subscribe { model in
            let vc = TypeDescriptionViewController()
            self.viewModel.getTypeFromURL(url: model.element?.url ?? "") { typeModel in
                vc.tipo.accept(typeModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: bag)
    }
    
    
}
