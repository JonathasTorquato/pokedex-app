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
    let types : BehaviorRelay<[GenericURLDTO]> = BehaviorRelay(value: [])
    
    @IBOutlet weak var typesCollectionVIew: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typesCollectionVIew.register(UINib(nibName: "TypeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "TypeCollectionCell")
        setupTable()
        self.viewModel.getTypes { types in
            self.types.accept(types)
        }
    }
    
    fileprivate func setupTable() {
        self.types.bind(to: typesCollectionVIew.rx.items(cellIdentifier: "TypeCollectionCell")) { row, type, cell in
            if let cell = cell as? TypeCollectionViewCell {
                cell.typeImageView.image = UIImage(named: type.name)
                cell.widthImageView.constant = 100
                cell.heightImageView.constant = 100
                cell.upperView.alpha = 0
            }
            
        }.disposed(by: bag)
        self.typesCollectionVIew.rx.modelSelected(GenericURLDTO.self).subscribe { model in
            let vc = TypeDescriptionViewController()
            self.viewModel.getTypeFromURL(url: model.element?.url ?? "") { typeModel in
                vc.tipo.accept(typeModel)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: bag)
    }
    
    
}
