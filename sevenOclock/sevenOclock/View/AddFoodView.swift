//
//  AddFoodView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/28.
//

import SwiftUI

struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var foodList: [Food] = []
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach($foodList, id: \.self) { $food in
                        FoodInputCard(food: $food, list: $foodList)
                            .font(.suite(.bold, size: 15))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.vertical, 25)
            }
            .onAppear {
                // TODO: Replace dummy data
                foodList.append(Food.dummyData2)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("취소")
                        .font(.suite(.regular, size: 16))
                        .onTapGesture {
                            dismiss()
                        }
                }
                ToolbarItem(placement: .principal) {
                    Text("식품 입력")
                        .font(.suite(.semibold, size: 17))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("완료")
                        .font(.suite(.bold, size: 16))
                        .onTapGesture {
                            // TODO: Save input information
                            dismiss()
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
    
    struct FoodInputCard: View {
        @Binding var food: Food
        @Binding var list: [Food]
        @State var category = "육류"
        @State var preservation = "냉장"
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundStyle(.grey0).opacity(0.6)
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 5)
                        .onTapGesture {
                            // TODO: Remove this element
                            list = list.filter { $0.id != food.id }
                        }
                }
                
                HStack(spacing: 12) {
                    Text("이름")
                    MyTextField(text: $food.name)
                }
                
                HStack(spacing: 12) {
                    Text("수량")
                    Stepper(value: $food.count, in: 1...99) {
                        Text("\(food.count)")
                            .font(.suite(.regular, size: 15))
                            .padding(.horizontal, 15)
                            .background(ZStack {RoundedRectangle(cornerRadius: 17)
                                    .frame(height: 34)
                                    .foregroundStyle(.white)
                                
                                RoundedRectangle(cornerRadius: 17)
                                    .stroke(lineWidth: 1.5)
                                    .frame(height: 34)
                                    .foregroundStyle(.grey1)})
                    }
                }
                
                HStack(spacing: 12) {
                    Text("분류")
                    SelectionBar(selections: Category.casesStringArray(), selected: $category)
                }
                
                myDivider
                    .padding(.vertical, 5)
                    .padding(.horizontal, -17)
                
                HStack(spacing: 12) {
                    Text("소비기한")
                    DatePicker("Use By Date", selection: $food.usebyDate, displayedComponents: .date)
                        .labelsHidden()
                }
                
                myDivider
                    .padding(.vertical, 5)
                    .padding(.horizontal, -17)
                
                HStack(spacing: 12) {
                    Text("저장 방법")
                    SelectionBar(selections: Preservation.casesStringArray(), selected: $preservation)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 20)
            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundStyle(.lightBlue))
        }
        
        var myDivider: some View {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.white)
        }
    }
    
    struct MyTextField: View {
        @Binding var text: String
        
        @FocusState private var isFocused: Bool
        @State var isSearching = false
        
        var body: some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 17)
                    .frame(height: 34)
                    .foregroundStyle(.white)
                
                RoundedRectangle(cornerRadius: 17)
                    .stroke(lineWidth: 1.5)
                    .frame(height: 34)
                    .foregroundStyle(.grey1)
                
                HStack {
                    ZStack(alignment: .leading) {
                        TextField("", text: $text) { startedEditing in
                            if startedEditing {
                                isFocused = true
                                withAnimation {
                                    isSearching = true
                                }
                            }
                        } onCommit: {
                            isFocused = false
                            withAnimation {
                                isSearching = false
                            }
                        }
                        .focused($isFocused)
                        .foregroundStyle(.grey0)
                        .padding(.horizontal, 15)
                    }
                    
                    if isFocused {
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                text = ""
                                isFocused = false
                                withAnimation {
                                    isSearching = false
                                    UIApplication.shared.dismissKeyboard()
                                }
                            }
                            .padding(.trailing, 10)
                    }
                }
            }
            .foregroundStyle(.grey0)
            .font(.suite(.regular, size: 15))
        }
    }
}

#Preview {
    AddFoodView(foodList: [Food.dummyData, Food.dummyData1])
}
