//
//  ContentView.swift
//  MovieBrowser
//
//  Created by Artur Bagautdinov on 17.12.2025.
//

import SwiftUI

struct MoviesListView: View {
    
    @State var viewModel = MoviesViewModel()
    @State private var showingAddSheet = false

    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]

    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach($viewModel.movies) { $movie in
                            NavigationLink {
                                MovieDetailView(movie: $movie)
                            } label: {
                                MovieRowView(movie: movie)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            viewModel.remove(movie)
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.hidden)
            }
            .background(
                Color.backgroundColor
            )
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Add", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    AddMovieView(viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    MoviesListView(viewModel: MoviesViewModel())
}
