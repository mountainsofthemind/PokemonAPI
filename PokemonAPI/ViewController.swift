//
//  ViewController.swift
//  PokemonAPI
//
//  Created by Field Employee on 12/9/20.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var pokemonImageView: UIImageView?
    @IBOutlet weak var pokemonNameLabel: UILabel?
    
    var pokemonArray: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getSingularPokemon()
        self.getSixPokemon()
    }
    
    private func getSixPokemon() {
        self.pokemonTableView.register(UINib(nibName:
            "PokemonTableViewCell", bundle: nil),
            forCellReuseIdentifier:
            "PokemonTableViewCell")
        self.pokemonTableView.dataSource = self
        
        let group = DispatchGroup()
        for _ in 1...6 {
        group.enter()
        NetworkingManager.shared
        .getDecodedObject(from:
        self.createRandomPokemonURL()) { (pokemon:
        Pokemon?, error) in
        guard let pokemon = pokemon else { return }
        self.pokemonArray.append(pokemon)
            group.leave()
        }
       }
        group.notify(queue: .main) {
            self.pokemonTableView.reloadData()
        }
    }
    
    private func getSingularPokemon() {
        NetworkingManager.shared
            .getDecodedObject(from:
            self.createRandomPokemonURL()) {
                (pokemon:Pokemon?, error) in
            guard let pokemon = pokemon else {
                if let error = error {
                   let alert = self.generateAlert(from:
                    error)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true,
                                     completion: nil)
                    }
                }
                return
            }
                DispatchQueue.main.async {
                    self.pokemonNameLabel?.text = pokemon.name
                }
                NetworkingManager.shared.getImageData(from:
                    pokemon.frontImageURL) { data, error in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                     self.pokemonImageView?.image =
                        UIImage(data: data)
                    }
                }
            }
        
        
    }
    private func createRandomPokemonURL() -> String
    {
        let randomNumber = Int.random(in:1...151)
        return "https://pokeapi.co/api/v2/pokemon/\(randomNumber)"
    }
    
    
    private func generateAlert(from error: Error)
    -> UIAlertController {
        let alert = UIAlertController(title: "Error",
        message: "We ran into an error! Error Description:\(error.localizedDescription)",
        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonArray.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        let cell =
            tableView
            .dequeueReusableCell(withIdentifier:
            "PokemonTableViewCell", for: indexPath) as!
        PokemonTableViewCell
        cell.configure(with:
        self.pokemonArray[indexPath.row])
        return cell
    }
}



