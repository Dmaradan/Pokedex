//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Diego Martin on 8/16/23.
//

import SwiftUI

struct PokemonListView: View {
    
    @StateObject var pokemonVM = PokemonViewModel()
    
    var body: some View {
        
        //var fillerData = ["Charizard", "Pikachu"]
        
        VStack {
            NavigationStack {
                List(pokemonVM.results, id: \.self) { pokemon in
                    Text(pokemon.name)
                        .font(.title2)
                }
                .listStyle(.plain)
                .navigationTitle("Pokemon")
            }
            .task {
                await pokemonVM.getData()
            }
        }
        .padding()
    }
}

#Preview {
    PokemonListView()
}
