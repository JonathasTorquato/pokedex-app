//
//  TypeDescriptionViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 26/04/22.
//

import UIKit
import AVKit
import AVFoundation

class TypeDescriptionViewController: UIViewController {

    fileprivate var playerObserver: Any?

    @IBOutlet weak var imageTypeView: UIImageView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var otherView: UIView!
    
    var indexPath1 : IndexPath?
    var tipo : TypeDTO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentTableView.register(UINib(nibName: "TypeTableViewCell", bundle: .main), forCellReuseIdentifier: "TypeTableViewCell")
        contentTableView.dataSource = self
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        gradient.frame = otherView.bounds
        otherView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        otherView.layer.addSublayer(gradient)
    }
    
    deinit{
        guard let observer = playerObserver else { return }
        NotificationCenter.default.removeObserver(observer)
    }
    
    func setupType(type : TypeDTO){
        self.tipo = type
        DispatchQueue.main.async {
            self.setupBackgroundVideo(type: type.name)
            self.imageTypeView.image = UIImage(named: type.name)
            self.title = TypePortuguese.getTypePortuguese(name: type.name)
            self.contentTableView.reloadData()
        }
    }
    
    fileprivate func setupBackgroundVideo(type name: String) {
        if let path = Bundle.main.path(forResource: "\(name)Type", ofType: "mp4"){
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            let layer = AVPlayerLayer(player: player)
            layer.frame = view.bounds
            layer.videoGravity = .resizeAspectFill
            view.layer.insertSublayer(layer, below: otherView.layer)
            player.volume = 0
            player.play()
            
            playerObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notification in
                player.seek(to: CMTime.zero)
                player.play()
            }
            
            
            
        }
    }
    
    
}

extension TypeDescriptionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TypeTableViewCell", for: indexPath) as? TypeTableViewCell, let tipo = self.tipo else {
            return UITableViewCell()
        }
        cell.delegate = self
        if row == 0 {
            self.indexPath1 = indexPath
            cell.nameLabel.text = "Dobro de dano de:"
            cell.tipos.accept(tipo.damage_relations.doubleDamageFrom)
        }
        else if row == 1 {
            cell.nameLabel.text = "Dobro de dano em:"
            cell.tipos.accept(tipo.damage_relations.doubleDamageTo)
        }
        else if row == 2 {
            cell.nameLabel.text = "Metade de dano de:"
            cell.tipos.accept(tipo.damage_relations.halfDamageFrom)
        }
        else if row == 3 {
            cell.nameLabel.text = "Metade de dano em:"
            cell.tipos.accept(tipo.damage_relations.halfDamageTo)
        }
        else if row == 4 {
            cell.nameLabel.text = "Imune à:"
            cell.tipos.accept(tipo.damage_relations.noDamageFrom)
        }
        else if row == 5 {
            cell.nameLabel.text = "Não dá dano em:"
            cell.tipos.accept(tipo.damage_relations.noDamageTo)
        }
        return cell
    }
    
    
}

extension TypeDescriptionViewController : TypeTableViewCellDelegate {
    func selectedType(type: TypeDTO) {
        self.contentTableView.scrollToRow(at: self.indexPath1!, at: .top, animated: false)
        self.setupType(type: type)
    }
}
