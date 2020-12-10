//
//  ViewController.swift
//  PokemonAPI
//
//  Created by Field Employee on 12/9/20.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared
            .getDecodedObject(from:
            self.createRandomPokemonURL()) {
                (pokemon:Pokemon?, error) in
            guard let pokemon = pokemon else { return }
                DispatchQueue.main.async {
                    self.pokemonNameLabel.text = pokemon.name
                }
                NetworkingManager.shared.getImageData(from:
                    pokemon.frontImageURL) { data, error in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                     self.pokemonImageView.image =
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
}



