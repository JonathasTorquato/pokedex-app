//
//  ItemsCell.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 25/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class ItemsCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    let bag = DisposeBag()
    let item : PublishRelay<ItemDTO> = PublishRelay<ItemDTO>()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupItem()
    }
    
    func setupItem() {
        item.subscribe(onNext: { value in
            self.itemName.text = value.name
            if let url = URL(string: value.sprites.defaultSprite){
                GetImage.downloadImage(from: url, imageView: self.itemImageView)
            }
        }).disposed(by: bag)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
