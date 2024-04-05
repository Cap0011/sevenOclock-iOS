//
//  MyFridgeView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/26.
//

import SwiftUI

struct MyFridgeView: View {
    @State var searchTitle = ""
    @State var selectedCategory = Category.all
    @State var selectedPreservation = Preservation.fridge
    @State var selectedSortOption = SortOption.byDateDESC.rawValue
    @State var isDateTagSelected = false
    @State var viewBySell = true
    @State var isShowingAddConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing, spacing: 0) {
                SearchBar(searchTitle: $searchTitle)
                    .padding(.top, 15)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                
                category
                    .padding(.bottom, 20)
                
                segmentedPicker
                    .padding(.horizontal, 25)
                
                sortSpace
                    .padding(.horizontal, 25)
                    .padding(.top, 23)
                
                FoodGridView(foods: [Food.dummyData, Food.dummyData1, Food.dummyData2, Food.dummyData3], backgroundColour: .blue, preservation: selectedPreservation, viewBySell: viewBySell)
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                
                radioButtonGroup
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
            }
            .confirmationDialog("Add", isPresented: $isShowingAddConfirmation) {
                Text("영수증 촬영")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("add")
                        .onTapGesture {
                            isShowingAddConfirmation = true
                        }
                }
                ToolbarItem(placement: .principal) {
                    Text("나의 냉장고")
                        .font(.suite(.semibold, size: 17))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "gearshape.fill")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var category: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Category.allCases, id: \.self) { category in
                    MyCapsule(isSelected: isThisSelected(category: category), textColour: isThisSelected(category: category) ? .white : .gray, colour: isThisSelected(category: category) ? .gray : .gray, text: category.rawValue)
                        .onTapGesture {
                            selectedCategory = category
                        }
                }
            }
            .frame(height: 38)
            .padding(.horizontal, 25)
        }
    }
    
    var segmentedPicker: some View {
        Picker("Preservation", selection: $selectedPreservation) {
            ForEach(Preservation.allCases, id: \.self) {
                Text($0.rawValue)
            }
            .pickerStyle(.segmented)
        }
        .pickerStyle(.segmented)
    }
    
    var sortSpace: some View {
        HStack {
            SelectionBar(selections: SortOption.allCasesStringArray(), selected: $selectedSortOption)
            
            Spacer()
            
            MyCapsule(isSelected: isDateTagSelected, textColour: isDateTagSelected ? .white : .red, colour: .red, text: "기한 임박")
                .onTapGesture {
                    isDateTagSelected.toggle()
                }
        }
    }
    
    var radioButtonGroup: some View {
        HStack(spacing: 15) {
            HStack(spacing: 4) {
                Image(systemName: viewBySell ? "checkmark.circle.fill" : "checkmark.circle")
                Text("유통기한으로 보기")
            }
            .foregroundStyle(viewBySell ? .black : .gray)
            .onTapGesture {
                viewBySell = true
            }
            
            HStack(spacing: 4) {
                Image(systemName: !viewBySell ? "checkmark.circle.fill" : "checkmark.circle")
                Text("소비기한으로 보기")
            }
            .foregroundStyle(!viewBySell ? .black : .gray)
            .onTapGesture {
                viewBySell = false
            }
        }
        .font(.suite(.regular, size: 14))
    }
    
    struct FoodGridView: View {
        let layout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        let foods: [Food]
        let backgroundColour: Color
        let preservation: Preservation
        
        @State var viewBySell: Bool
        
        var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: layout) {
                    ForEach(foods, id: \.id) { food in
                        VStack(spacing: 0) {
                            FoodItem(item: food, date: viewBySell ? food.sellbyDate : food.usebyDate)
                                .padding(.top, 10)
                                .padding(.bottom, 15)
                            
                            RoundedRectangle(cornerRadius: 2.0)
                                .frame(height: 4)
                                .foregroundStyle(.white)
                                .padding(.horizontal, -5)
                                .opacity(0.8)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 5)
                .padding(.horizontal, 15)
                
            }
            .background(Image(preservation.imageName()).resizable().scaledToFill().allowsHitTesting(false))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    func isThisSelected(category: Category) -> Bool {
        return selectedCategory == category
    }
}

#Preview {
    MyFridgeView()
}
