//
//  ItemDescriptionViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 26/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class ItemDescriptionViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    var firstItem : ItemDTO?
    
    let bag = DisposeBag()
    let item : PublishRelay<ItemDTO> = PublishRelay<ItemDTO>()
    
    init(item : ItemDTO){
        super.init(nibName: "ItemDescriptionViewController", bundle: .main)
        self.firstItem = item
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItem()
        if let firstItem = firstItem {
            self.item.accept(firstItem)
        }
    }
    
    fileprivate func setupItem() {
        item.subscribe(onNext: { value in
            DispatchQueue.main.async {
                self.title = value.name
                self.itemDescriptionLabel.text = value.effect_entries.first?.effect
                if let url = URL(string: value.sprites.defaultSprite){
                    GetImage.downloadImage(from: url, imageView: self.itemImageView)
                }
            }
        }).disposed(by: bag)
    }
    


}
