//
//  HomeScreen.swift
//  BengaliWordSearch
//
//  Created by Taher's nimble macbook on 25/3/2567 BE.
//

import Combine
import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel: HomeViewModel
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var copiedWord: String = ""
    @State private var isPresentWebView = false
    
    private var suffixView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.suffixMatchWords, id: \.self) { word in
                    Text(word)
                        .padding(.bottom, 2.0)
                        .onTapGesture(count: 2) {
                            handleDoubleTap(for: word)
                        }
                        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 30) {
                            processCopyText(word: word)
                        } onPressingChanged: { _ in
                            
                        }
                }
            }
        }
    }
    
    private var prefixView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.prefixMatchWords, id: \.self) { word in
                    Text(word)
                        .padding(.bottom, 2.0)
                        .onTapGesture(count: 2) {
                            handleDoubleTap(for: word)
                        }
                        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 30) {
                            processCopyText(word: word)
                        } onPressingChanged: { _ in
                            
                        }
                }
            }
        }
    }
    
    private var copyTextToast: some View {
        Text("\(copiedWord) copied to clipboard")
            .foregroundStyle(Color.black)
            .padding(8.0)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.7))
            .cornerRadius(16.0)
    }
    
    private var contentView: some View {
        VStack {
            switch viewModel.state {
                case .loading:
                    ProgressView()
                case .loaded:
                    VStack {
                        if !copiedWord.isEmpty {
                            copyTextToast
                        }
                        HStack {
                            prefixView
                            Spacer()
                            suffixView
                        }
                        .padding(.top, 8.0)
                    }
                    .padding()
                    .animation(.linear, value: copiedWord.isEmpty)
                case .error:
                    Text("Error")
                    Button("Try again", action: viewModel.tryAgain)
                    
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Search Bengali Word")
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "write word here"
                )
                .padding()
                .animation(.linear, value: isPresentWebView)
                .sheet(isPresented: $isPresentWebView) {
                    NavigationStack {
                        if let url = viewModel.wordMeaningURL {
                            WebView(url: url)
                                .ignoresSafeArea()
                                .navigationTitle("Word Meaning")
                                .navigationBarTitleDisplayMode(.inline)
                            
                        } else {
                            Text("Wrong URL")
                        }
                    }
                    .presentationDetents([.fraction(0.7)])
                }
        }
        .onAppear {
            viewModel.viewAppear()
            stopTimer()
        }
        .onReceive(timer) { value in
            copiedWord = ""
            stopTimer()
        }
    }
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    }
    
    private func processCopyText(word: String) {
        UIPasteboard.general.string = word
        copiedWord = word
        startTimer()
    }
    
    private func handleDoubleTap(for word: String) {
        viewModel.onSelectWord(word: word)
        isPresentWebView = true
    }
}
