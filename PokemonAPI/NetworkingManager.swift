//
//  NetworkingManager.swift
//  PokemonAPI
//
//  Created by Field Employee on 12/9/20.
//

import Foundation

final class NetworkingManager {
    static let shared = NetworkingManager()
    private init() { }
    func getDecodedObject<T: Decodable>(from urlString: String, completion: @escaping (T?, Error?) -> Void) {
            guard let url = URL(string: urlString) else {
                return }
            URLSession.shared.dataTask(with:url) {
                (data, response, error) in
                guard let data = data else { return }
                guard let pokemon = try?
                        JSONDecoder().decode(T.self, from: data) else { return }
                completion(pokemon, nil)
            }.resume()
        }
    
    func getImageData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, error)
        }.resume()
    }
}
