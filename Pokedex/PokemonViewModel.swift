//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Diego Martin on 8/19/23.
//

import Foundation

class PokemonViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String
        
        var results: [Result]
        
        init(count: Int, next: String, results: [Result]) {
            self.count = count
            self.next = next
            self.results = results
        }
    }
    
    struct Result: Codable, Hashable {
        var name: String
        var url: String
    }
    
    @Published var results: [Result] = []
    
    var urlString = "https://pokeapi.co/api/v2/pokemon/"
    
    func getData() async {
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create a URL from \(urlString)")
            return
        }
        
        // Try to make the shared session with the URL
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decode the JSON data into our own structure
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("ERROR: Could not decode JSON data from \(urlString)")
                return
            }
            print("😎 JSON data decoded successfully")
            results = returned.results
        } catch {
            print("ERROR: Could not retrieve data from \(urlString)")
        }
    }
}
