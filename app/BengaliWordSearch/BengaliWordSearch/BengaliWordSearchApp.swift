//
//  BengaliWordSearchApp.swift
//  BengaliWordSearch
//
//  Created by Taher's nimble macbook on 25/3/2567 BE.
//

import SwiftUI

@main
struct BengaliWordSearchApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen(viewModel: HomeViewModel())
        }
    }
}
