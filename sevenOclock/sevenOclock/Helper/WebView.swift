//
//  WebView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/07.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webView = WKWebView()

        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
}

struct WebViewContainer: View {
    let url: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            WebView(url: url)
                .navigationBarItems(leading: Button("닫기") {
                    dismiss()
                })
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
