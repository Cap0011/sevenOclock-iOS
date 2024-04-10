//
//  ChartView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/06.
//

import SwiftUI

struct ChartView: View {
    @FetchRequest(entity: Food.entity(), sortDescriptors: []) var foods: FetchedResults<Food>
    
    @State private var title = "식품 유형"
    
    @State private var categorySlices: [(String, Double, Color)] = []
    @State private var dateSlices: [(String, Double, Color)] = []
    
    @State private var currentSlices: [(String, Double, Color)] = []
    
    let colours: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .black.opacity(0.15), .black.opacity(0.3), .black.opacity(0.45), .black.opacity(0.6), .black.opacity(0.75), .black.opacity(0.9), .black]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Divider()
                        .padding(.horizontal, -20)
                    
                    header
                        .padding(.top, 20)
                    
                    chart
                        .padding(.top, 30)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("냉장고 분석")
                        .font(.suite(.semibold, size: 17))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            title = "식품 유형"
            
            getCategorySlices()
            getDateSlices()
            
            currentSlices = categorySlices
        }
        .onChange(of: title) { _ in
            if title == "식품 유형" {
                currentSlices = categorySlices
            } else {
                currentSlices = dateSlices
            }
        }
    }
    
    private func getCategorySlices() {
        var colourIndex = 0
        categorySlices = []
        
        for category in Category.casesStringArray() {
            let count = foods.filter { $0.category == category }.count
            if count > 0 {
                categorySlices.append((category, Double(count), colours[colourIndex]))
                colourIndex += 1;
            }
        }
    }
    
    private func getDateSlices() {
        dateSlices = []
        
        let redArray = foods.filter { ($0.usebyDate?.daysLeft())! <= 3 }
        let orangeArray = foods.filter { ($0.usebyDate?.daysLeft())! <= 7 }
        let greenArray = foods.filter { ($0.usebyDate?.daysLeft())! > 7 }
        
        if redArray.count > 0 {
            dateSlices.append(("3일 이하", Double(redArray.count), .red))
        }
        if orangeArray.count > 0 {
            dateSlices.append(("7일 미만", Double(orangeArray.count), .orange))
        }
        if redArray.count > 0 {
            dateSlices.append(("7일 이상", Double(greenArray.count), .green))
        }
    }
    
    struct Pie: View {
        let slices: [(Double, Color)]

        var body: some View {
            Canvas { context, size in
                let total = slices.reduce(0) { $0 + $1.0 }
                context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
                var pieContext = context
                pieContext.rotate(by: .degrees(-90))
                let radius = min(size.width, size.height) * 0.48
                var startAngle = Angle.zero
                for (value, color) in slices {
                    let angle = Angle(degrees: 360 * (value / total))
                    let endAngle = startAngle + angle
                    let path = Path { p in
                        p.move(to: .zero)
                        p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                        p.closeSubpath()
                    }
                    pieContext.fill(path, with: .color(color))

                    startAngle = endAngle
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
    
    struct DetailRow: View {
        let colour: Color
        let title: String
        let percentage: Int
        let count: Int
        
        var body: some View {
            HStack(spacing: 0) {
                Rectangle()
                    .foregroundStyle(colour)
                    .frame(width: 10, height: 10)
                    .padding(.trailing, 6)
                
                Text(title)
                    .font(.suite(.semibold, size: 17))
                    .padding(.trailing, 5)
                
                Text("\(percentage)%")
                    .font(.suite(.regular, size: 15))
                
                Spacer()
                
                Text("\(count) 품목")
                    .font(.suite(.medium, size: 17))
                    .padding(.trailing, 12)
                
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.grey0)
            }
            .padding(.horizontal, 25)
            .foregroundStyle(.black.opacity(0.8))
        }
    }
    
    var header: some View {
        ZStack(alignment: title == "남은 기한" ? .leading : .trailing) {
            if title == "남은 기한" {
                Image(systemName: "chevron.backward")
                    .padding(.leading, 5)
                    .onTapGesture {
                        title = "식품 유형"
                    }
            }
            HStack {
                Spacer()
                Text(title)
                Spacer()
            }
            if title == "식품 유형" {
                Image(systemName: "chevron.forward")
                    .padding(.trailing, 5)
                    .onTapGesture {
                        title = "남은 기한"
                    }
            }
        }
        .font(.suite(.bold, size: 17))
    }
    
    var chart: some View {
        VStack(spacing: 0) {
            ZStack {
                Pie(slices: currentSlices.map { ($0.1, $0.2) })
                .padding(.horizontal, 75)
                
                Circle()
                    .foregroundStyle(.grey2)
                    .frame(width: 100)
            }
            .padding(.vertical, 45)
            
            VStack(spacing: 10) {
                ForEach(currentSlices, id: \.self.0) { slice in
                    DetailRow(colour: slice.2, title: slice.0, percentage: Int((slice.1 / currentSlices.reduce(0) { $0 + $1.1 }) * 100), count: Int(slice.1))
                }
            }
        }
        .padding(.bottom, 50)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.grey2))
    }
}

#Preview {
    ChartView()
}
