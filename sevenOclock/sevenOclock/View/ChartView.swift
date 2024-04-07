//
//  ChartView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/06.
//

import SwiftUI

struct ChartView: View {
    @State private var title = "식품 유형"
    
    @State private var categorySlices: [(Double, Color)] = []
    @State private var dateSlices: [(Double, Color)] = []
    
    @State private var currentSlices: [(Double, Color)] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                header
                    .padding(.top, 25)
                
                chart
                    .padding(.top, 30)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            categorySlices = [(2, .red), (1, .orange), (5, .yellow), (3, .green), (6, .blue), (4, .indigo)]
            dateSlices = [(2, .green), (3, .orange), (4, .red)]
            
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
                Pie(slices: currentSlices)
                .padding(.horizontal, 75)
                
                Circle()
                    .foregroundStyle(.grey2)
                    .frame(width: 100)
            }
            .padding(.vertical, 45)
            
            VStack(spacing: 10) {
                ForEach(currentSlices, id: \.self.1) { slice in
                    DetailRow(colour: slice.1, title: "육류", percentage: Int(slice.0), count: 2)
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
