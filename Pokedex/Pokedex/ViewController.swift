//
//  ViewController.swift
//  Pokedex
//
//  Created by Andrade Torquato, Jonathas on 02/03/22.
//

import UIKit

class ViewController: UIViewController {

    var numberOfCells = 0
    let viewModel: MainViewModel = MainViewModel()
    var size:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: .main), forCellReuseIdentifier: "PokemonTableCell")
        tableView.register(UINib(nibName: "FooterTableCell", bundle: .main), forCellReuseIdentifier: "FooterCell")
        getCount()
    }

    func getCount(){
        viewModel.getPokemonCount { count in
            self.size = count
            self.numberOfCells = 10
            self.tableView.reloadData()
        }
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
        if numberOfCells > size{
            numberOfCells = size
        }
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
            if numberOfCells >= size{
                cell.loadMoreButton.isHidden = true
                cell.noMorePokemonLabel.isHidden = false
            }
            else
            {
                cell.loadMoreButton.isHidden = false
                cell.noMorePokemonLabel.isHidden = true
            }
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
