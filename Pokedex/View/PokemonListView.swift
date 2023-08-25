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
        VStack {
            NavigationStack {
                List(0..<pokemonVM.results.count, id: \.self) { index in
                    LazyVStack {
                        NavigationLink {
                            DetailView(pokemon: pokemonVM.results[index])
                        } label: {
                            Text("\(index + 1). " + pokemonVM.results[index].name.capitalized)
                                .font(.title2)
                        }
                    }
                    .onAppear {
                        
                        if let lastPokemon = pokemonVM.results.last {
                            if lastPokemon.name == pokemonVM.results[index].name && pokemonVM.urlString.hasPrefix("http") {
                                Task {
                                    await pokemonVM.getData()
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokemon")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Text("\(pokemonVM.results.count) out of \(pokemonVM.count) pokemon")
                    }
                }
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
