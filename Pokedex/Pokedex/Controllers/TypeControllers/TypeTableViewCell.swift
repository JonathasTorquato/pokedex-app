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
    func selectedType(type : TypeDTO)
}

class TypeTableViewCell: UITableViewCell {

    @IBOutlet weak var relationsTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let bag = DisposeBag()
    let tipos: PublishRelay<[TypeURLDTO]> = PublishRelay<[TypeURLDTO]>()
    
    var delegate : TypeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        relationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupTable()
    }
    
    fileprivate func setupTable() {
        tipos.bind(to: relationsTableView.rx.items(cellIdentifier: "cell")){row,tipo,cell in
            cell.textLabel?.text = TypePortuguese.getTypePortuguese(name: tipo.name, cell.textLabel)
        }.disposed(by: bag)
        relationsTableView.rx.modelSelected(TypeURLDTO.self).subscribe{ type in
            guard let url = type.element?.url else {return}
            Network.getTypeURL(url: url) { result in
                switch result {
                    
                case .success(let success):
                    self.delegate?.selectedType(type: success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }.disposed(by: bag)
    }
    
    
}
