//
//  TypeTableViewCell.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 27/04/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol TypeTableViewCellDelegate {
    func selectedType(type : TypeModel)
}

class TypeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var relationsCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let bag = DisposeBag()
    let tipos: PublishRelay<[GenericURLDTO]> = PublishRelay<[GenericURLDTO]>()
    let viewModel = TypeTableViewCellViewModel()
    
    var delegate : TypeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        relationsCollectionView.register(UINib(nibName: "TypeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "TypeCollectionCell")
        setupTable()
    }
    
    fileprivate func setupTable() {
        tipos.bind(to: relationsCollectionView.rx.items(cellIdentifier: "TypeCollectionCell")){row,tipo,cell in
            
            if let cell = cell as? TypeCollectionViewCell {
                cell.backgroundColor = .clear
                cell.upperView.alpha = 0
                cell.typeImageView.image = UIImage(named: tipo.name)
            }
        }.disposed(by: bag)
        relationsCollectionView.rx.modelSelected(GenericURLDTO.self).subscribe{ type in
            guard let url = type.element?.url else {return}
            self.viewModel.retrieveType(url: url) { typeM in
                self.delegate?.selectedType(type: typeM)
            }
        }.disposed(by: bag)
    }
    
    
}
