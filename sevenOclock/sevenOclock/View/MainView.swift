//
//  MainView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChartView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("냉장고 분석")
                }
                .tag(0)
            MyFridgeView()
                .tabItem {
                    Image(systemName: "refrigerator.fill")
                    Text("나의 냉장고")
                }
                .tag(1)
            RecipeView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("레시피")
                }
                .tag(2)
        }
        .font(.headline)
    }
}

#Preview {
    MainView()
}
