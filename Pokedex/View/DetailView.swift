//
//  DetailView.swift
//  Pokedex
//
//  Created by Diego Martin on 8/23/23.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var detailVM = DetailViewModel()
    var pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(pokemon.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.bottom)
            HStack {
                AsyncImage(url: URL(string: detailVM.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .background(.white)
                        .frame(maxWidth: 96)
                        .cornerRadius(16)
                        .shadow(radius: 8, x: 5, y: 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                                
                        }
                        .padding(.trailing)
                } placeholder: {
                    Image(systemName: "cloud")
                        .resizable()
                        .scaledToFit()
                        .background(.white)
                        .frame(maxWidth: 96)
                        .cornerRadius(16)
                        .shadow(radius: 8, x: 5, y: 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                                
                        }
                        .padding(.trailing)
                }

                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        Text(String(format: "%.1f", detailVM.height))
                             .font(.largeTitle)
                             .bold()
                             
                    }
                    HStack(alignment: .top) {
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)
                        Text(String(format: "%.1f", detailVM.weight))
                             .font(.largeTitle)
                             .bold()
                             
                    }
                }
                
            }
            
            Spacer()
        }
        .padding()
        .task {
            detailVM.urlString = pokemon.url
            await detailVM.getData()
        }
    }
}

#Preview {
    DetailView(pokemon: Pokemon(name: "Dartanyan", url: ""))
}
