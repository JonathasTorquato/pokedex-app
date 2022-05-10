//
//  TypeDescriptionViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 26/04/22.
//

import UIKit
import AVKit
import AVFoundation
import RxSwift
import RxCocoa

//MARK: - Declarations
class TypeDescriptionViewController: UIViewController {

    fileprivate var playerObserver: Any?

    @IBOutlet weak var imageTypeView: UIImageView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var otherView: UIView!
    
    let layer : AVPlayerLayer = {
        let player = AVPlayer()
        return AVPlayerLayer(player: player)
    }()
    let bag = DisposeBag()
    let relacoes : BehaviorRelay<[[String:[GenericURLDTO]]]> = BehaviorRelay(value:[])
    let tipo : BehaviorRelay<TypeModel> = BehaviorRelay(value: TypeModel(name:"", relacoes: []))
    
    deinit {
        if let observer = playerObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}

//MARK: - Methods
extension TypeDescriptionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        contentTableView.register(UINib(nibName: "TypeTableViewCell", bundle: .main), forCellReuseIdentifier: "TypeTableViewCell")
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        gradient.frame = otherView.bounds
        otherView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        otherView.layer.addSublayer(gradient)
        setupTypeRX()
        setupTable()
        
        
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        
        view.layer.insertSublayer(layer, below: otherView.layer)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController{
            navigationController.navigationItem.leftBarButtonItem?.customView?.backgroundColor = .link
            navigationController.navigationBar.barTintColor = .clear
            navigationController.navigationBar.backgroundColor = .clear
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
    //MARK: - Rx Setup
    fileprivate func setupTable() {
        self.relacoes.bind(to: contentTableView.rx.items(cellIdentifier: "TypeTableViewCell")) { row, relacao, cell  in
            
            guard let cell = cell as? TypeTableViewCell, let relacoesM = relacao[relacao.keys.first!]  else {return}
            cell.nameLabel.text = relacao.keys.first!
            cell.tipos.accept(relacoesM)
            cell.delegate = self
        }.disposed(by: bag)
    }
    
    fileprivate func setupTypeRX() {
        self.tipo.subscribe(onNext: { value in
            self.relacoes.accept(value.relacoes)
            DispatchQueue.main.async {
                self.setupBackgroundVideo(type: value.name)
                self.imageTypeView.image = UIImage(named: value.name)
                self.title = TypePortuguese.getTypePortuguese(name: value.name)
                self.contentTableView.reloadData()
            }
        }).disposed(by: bag)
    }
    
    //MARK: - Set Background Animation
    fileprivate func setupBackgroundVideo(type name: String) {
        if let path = Bundle.main.path(forResource: "\(name)Type", ofType: "mp4"){
            let player = AVPlayer(url: URL(fileURLWithPath: path))
            layer.player = player
            
            player.volume = 0
            player.play()
            
            if let observer = playerObserver { NotificationCenter.default.removeObserver(observer)}
            playerObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notification in
                player.seek(to: CMTime.zero)
                player.play()
            }
        }
    }
    
    
}

//MARK: - Cell Delegate
extension TypeDescriptionViewController :TypeTableViewCellDelegate {
    func selectedType(type: TypeModel) {
        if let index = self.contentTableView.indexPathForRow(at: CGPoint(x: 0, y: 0)){
            self.contentTableView.scrollToRow(at: index, at: .top, animated: false)
            self.tipo.accept(type)
        }
    }
}
