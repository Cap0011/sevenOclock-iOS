//
//  MainView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ChartView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("냉장고 분석")
                }
            MyFridgeView()
                .tabItem {
                    Image(systemName: "refrigerator.fill")
                    Text("나의 냉장고")
                }
            RecipeView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("레시피")
                }
        }
        .font(.headline)
    }
}

#Preview {
    MainView()
}
