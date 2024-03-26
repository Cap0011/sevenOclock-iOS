//
//  ContentView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/25.
//

import SwiftUI

struct ContentView: View {
    @State var searchTitle = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            SearchBar(searchTitle: $searchTitle)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
