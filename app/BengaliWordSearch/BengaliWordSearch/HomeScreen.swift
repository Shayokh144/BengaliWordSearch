//
//  HomeScreen.swift
//  BengaliWordSearch
//
//  Created by Taher's nimble macbook on 25/3/2567 BE.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel: HomeViewModel
    
    var suffixView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.suffixMatchWords, id: \.self) { word in
                    Text(word)
                }
            }
        }
    }
    
    var prefixView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.prefixMatchWords, id: \.self) { word in
                    Text(word)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
                case .loading:
                    ProgressView()
                case .loaded:
                    HStack {
                        suffixView
                        Spacer()
                        prefixView
                    }
                    .padding()
                case .error:
                    Text("Error")
                    Button("Try again", action: viewModel.tryAgain)
                    
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "write here"
        )
        .padding()
        .onAppear {
            viewModel.viewAppear()
        }
    }
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}
