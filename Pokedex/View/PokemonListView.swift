//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Diego Martin on 8/16/23.
//

import SwiftUI

struct PokemonListView: View {
    
    @StateObject var pokemonVM = PokemonViewModel()
    @State private var searchText = ""
    
    var searchResults: [Pokemon] {
        if searchText == "" {
            return pokemonVM.results
        } else {
            return pokemonVM.results.filter{$0.name.capitalized.contains(searchText)}
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationStack {
                    List(searchResults) { pokemon in
                        LazyVStack {
                            NavigationLink {
                                DetailView(pokemon: pokemon)
                            } label: {
                                Text(pokemon.name.capitalized)
                                    .font(.title2)
                            }
                        }
                        .onAppear {
                            
                            if let lastPokemon = pokemonVM.results.last {
                                if lastPokemon.id == pokemon.id && pokemonVM.urlString.hasPrefix("http") {
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
                        ToolbarItem(placement: .status) {
                            Text("\(pokemonVM.results.count) out of \(pokemonVM.count) pokemon")
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button("Load All") {
                                Task {
                                    await pokemonVM.loadAll()
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText)
                }
                .task {
                    await pokemonVM.getData()
                }
            }
            .padding()
            
            if pokemonVM.isLoading {
                ProgressView()
                    .tint(.red)
                    .scaleEffect(4)
            }
        }
        
    }
}

#Preview {
    PokemonListView()
}
