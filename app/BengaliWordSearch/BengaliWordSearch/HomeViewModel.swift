//
//  HomeViewModel.swift
//  BengaliWordSearch
//
//  Created by Taher's nimble macbook on 25/3/2567 BE.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published private(set) var wordList: [String]
    @Published private(set) var suffixMatchWords: [String]
    @Published private(set) var prefixMatchWords: [String]
    @Published private(set) var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        wordList = []
        suffixMatchWords = []
        prefixMatchWords = []
        state = .loaded
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.search(text: text)
                }
            }
            .store(in: &cancellables)
    }
    
    func viewAppear() {
        if wordList.isEmpty {
            loadWordList()
        }
    }
    
    private func search(text: String) {
        state = .loading
        prefixMatchWords.removeAll()
        suffixMatchWords.removeAll()
        for word in wordList {
            if word.hasPrefix(text) {
                prefixMatchWords.append(word)
            }
            if word.hasSuffix(text) {
                suffixMatchWords.append(word)
            }
        }
        state = .loaded
    }
    
    func tryAgain() {
        state = .loaded
        searchText = ""
    }
    
    
    private func loadWordList() {
        state = .loading
        guard let filePath = Bundle.main.path(forResource: "BengaliSortedWords", ofType: "txt") else {
            NSLog("File not found.")
            state = .error
            return
        }
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            wordList = fileContents.components(separatedBy: "\n")
            wordList = Array(Set(wordList))
            NSLog("Number of words found: \(wordList.count)")
            state = .loaded
        } catch {
            NSLog("Error reading file:", error.localizedDescription)
            state = .error
        }
    }
}

extension HomeViewModel {
    
    enum State {
        
        case loading
        case loaded
        case error
    }
}
