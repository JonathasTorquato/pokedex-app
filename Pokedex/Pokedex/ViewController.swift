//
//  ViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import UIKit

class ViewController: UIViewController {

    var numberOfCells = 10
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        tableView.register(UINib(nibName: "FooterTableCell", bundle: .main), forCellReuseIdentifier: "FooterCell")
    }


}
extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < numberOfCells
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableCell", for: indexPath) as! PokemonTableViewCell
            cell.setPokemon(indexPath.row + 1)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath) as! FooterTableCell
            cell.delegate = self
            return cell
        }
        
    }
    
    
}
extension ViewController: FooterTableCellDelegate
{
    func didTap()
    {
        numberOfCells += 10
        tableView.reloadData()
    }
}
