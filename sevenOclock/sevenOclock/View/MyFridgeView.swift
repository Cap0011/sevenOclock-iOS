//
//  MyFridgeView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/26.
//

import SwiftUI

struct MyFridgeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Food.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Food.usebyDate, ascending: true)]) var foods: FetchedResults<Food>
    
    var filteredFoods: [Food] {
        var result = Array(foods)
        
        if !searchTitle.isEmpty {
            result = foods.filter { $0.name!.localizedCaseInsensitiveContains(searchTitle) }
        }
        
        if selectedCategory != Category.all {
            result = result.filter { $0.category == selectedCategory.rawValue }
        }
        
        if selectedPreservation != Preservation.all {
            result = result.filter { $0.preservation == selectedPreservation.rawValue }
        }
        
        if isDateTagSelected {
            result = result.filter { ($0.usebyDate?.daysLeft())! <= 3 }
        }
        
        result.sort(by: { food1, food2 in
            return SortOption.fromRawValue(rawValue: selectedSortOption)!.sortDescriptor().compare(food1, to: food2) == .orderedAscending
        })
        
        return result
    }
    
    @State var searchTitle = ""
    @State var selectedCategory = Category.all
    @State var selectedPreservation = Preservation.fridge
    @State var selectedSortOption = SortOption.byDateDESC.rawValue
    @State var isDateTagSelected = false
    
    @State var isShowingAddConfirmation = false
    @State var isShowingAddSheet = false
    
    @State var selectedFood: Food?
    @State var isShowingAlert = false
    @State var inputText = ""
    
    @State private var updatedObject: Food?
    
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
                    .padding(.top, 15)
                
                FoodGridView(foods: filteredFoods, backgroundColour: Color.blue, preservation: selectedPreservation, isShowingAlert: $isShowingAlert, inputText: $inputText, selectedFood: $selectedFood)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 15)
            }
            .confirmationDialog("Add", isPresented: $isShowingAddConfirmation) {
                Button("영수증 촬영") {
                    // TODO: 영수증 촬영
                }
                Button("바코드 인식") {
                    // TODO: 바코드 인식
                }
                Button("직접 입력") {
                    isShowingAddSheet.toggle()
                }
                Button("취소", role: .cancel) { }
            } message: {
                Text("어떻게 냉장고에 추가하실 건가요?")
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddFoodView()
            }
            .alert("꺼낼 \(selectedFood?.name ?? "") 수량을 입력해 주세요.", isPresented: $isShowingAlert) {
                TextField("", text: $inputText)
                    .keyboardType(.decimalPad)
                    .autocorrectionDisabled()
                    
                Button("확인", action: {
                    // TODO: Update selectedFood count
                    if let count = Int(inputText) {
                        if let object = foods.first(where: { $0.id == selectedFood?.id }) {
                            if count >= object.count {
                                // Delete
                                managedObjectContext.delete(object)
                                saveContext()
                            } else {
                                // Update count property
                                object.count -= Int64(count)
                                updateFood(data: object)
                            }
                        }
                    } else {
                        // TODO: Show toast message
                    }
                })
                Button("취소", role: .cancel, action: {})
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("plusFridge")
                        .onTapGesture {
                            isShowingAddConfirmation = true
                        }
                }
                ToolbarItem(placement: .principal) {
                    Text("나의 냉장고")
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
    }
    
    var category: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Category.allCases, id: \.self) { category in
                    MyCapsule(isSelected: isThisSelected(category: category), textColour: isThisSelected(category: category) ? .white : .grey0, colour: isThisSelected(category: category) ? .grey0 : .grey0.opacity(0.6), text: category.rawValue)
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
            
            MyCapsule(isSelected: isDateTagSelected, textColour: isDateTagSelected ? .white : .tagRed, colour: .tagRed, text: "기한 임박")
                .onTapGesture {
                    isDateTagSelected.toggle()
                }
        }
    }
    
    struct FoodGridView: View {
        let layout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        let foods: [Food]
        let backgroundColour: Color
        let preservation: Preservation
        
        @Binding var isShowingAlert: Bool
        @Binding var inputText: String
        @Binding var selectedFood: Food?
                        
        var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: layout) {
                    ForEach(foods, id: \.id) { food in
                        VStack(spacing: 0) {
                            FoodItem(item: food, date: food.usebyDate ?? Date())
                                .padding(.top, 10)
                                .padding(.bottom, 15)
                                .onTapGesture {
                                    Task {
                                        selectedFood = food
                                        inputText = ""
                                        isShowingAlert.toggle()
                                    }
                                }
                            
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
                .padding(.bottom, 15)
                .padding(.horizontal, 15)
            }
            .background(Image(preservation.imageName()).resizable().scaledToFill().allowsHitTesting(false))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    func isThisSelected(category: Category) -> Bool {
        return selectedCategory == category
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func updateFood(data: Food) {
        let newFood = Food(context: managedObjectContext)
        newFood.id = data.id
        newFood.name = data.name
        newFood.count = data.count
        newFood.category = data.category
        newFood.subcategory = data.subcategory
        newFood.usebyDate = data.usebyDate
        newFood.preservation = data.preservation
        newFood.enrollDate = data.enrollDate
        
        managedObjectContext.delete(data)
        saveContext()
    }
}

#Preview {
    MyFridgeView()
}
