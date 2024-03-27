//
//  WebView.swift
//  BengaliWordSearch
//
//  Created by Taher's nimble macbook on 27/3/2567 BE.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    init(url: URL) {
        self.url = url
    }
}
