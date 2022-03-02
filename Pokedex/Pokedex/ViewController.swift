//
//  ViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
    }


}
extension ViewController: UITableViewDelegate
{
    
}
extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableCell", for: indexPath) as! PokemonTableViewCell
        cell.setPokemon(indexPath.row + 1)
        return cell
    }
    
    
}
