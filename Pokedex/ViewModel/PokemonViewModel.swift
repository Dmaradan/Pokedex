//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Diego Martin on 8/19/23.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String?
        
        var results: [Pokemon]
        
        init(count: Int, next: String, results: [Pokemon]) {
            self.count = count
            self.next = next
            self.results = results
        }
    }
    
    @Published var isLoading = false
    
    @Published var results: [Pokemon] = []
    @Published var count = 0
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon/"
    
    
    func getData() async {
        isLoading = true
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        // Try to make the shared session with the URL
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Decode the JSON data into our own structure
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("ERROR: Could not decode JSON data from \(urlString)")
                isLoading = false
                return
            }
            print("😎 JSON data decoded successfully")
            results += returned.results
            count = returned.count
            urlString = returned.next ?? ""
            isLoading = false
            
        } catch {
            print("ERROR: Could not retrieve data from \(urlString)")
            isLoading = false
        }
    }
    
    func loadAll() async {
        while urlString != "" {
            await getData()
        }
        
        print("👩‍🍳 Terminado")
    }
}
