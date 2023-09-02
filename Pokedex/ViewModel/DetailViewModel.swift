//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Diego Martin on 8/23/23.
//

import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var height: Double
        var weight: Double
        
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var front_default: String?
        var other: Other
    }
    
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Codable {
        var front_default: String?
    }
    
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL = ""
    
    var urlString = ""
    
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
            self.height = returned.height
            self.weight = returned.weight
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "n/a"
        } catch {
            print("ERROR: Could not retrieve data from \(urlString)")
        }
    }
}

