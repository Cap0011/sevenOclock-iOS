//
//  AddFoodView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/28.
//

import SwiftUI
import AlertToast

struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var foodList: [TemporaryFood]
    @State var isShowingToast = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    itemAddButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                        .onTapGesture {
                            foodList.append(TemporaryFood(id: UUID()))
                        }
                    
                    ForEach($foodList, id: \.self) { $food in
                        FoodInputCard(food: food, list: $foodList)
                            .font(.suite(.bold, size: 15))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.vertical, 25)
            }
            .onAppear {
                if foodList.isEmpty {
                    foodList.append(TemporaryFood(id: UUID()))
                }
            }
            .onDisappear {
                foodList = []
            }
            .toast(isPresenting: $isShowingToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "식품 이름을 입력해주세요.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
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
                            if foodList.map({ $0.name }).contains("") {
                                isShowingToast.toggle()
                            } else {
                                for food in foodList {
                                    addFood(data: food)
                                }
                                dismiss()
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
    
    var itemAddButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.lightBlue)
                .frame(height: 44)
            
            Text("식품 추가")
                .font(.suite(.semibold, size: 18))
                .foregroundStyle(.black)
        }
    }
    
    struct FoodInputCard: View {
        @StateObject var food: TemporaryFood
        @Binding var list: [TemporaryFood]
        
        @State var isTypingFinished = true

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundStyle(.grey0).opacity(0.6)
                        .font(.system(size: 18, weight: .regular))
                        .padding(.bottom, 5)
                        .onTapGesture {
                            list = list.filter { $0.id != food.id }
                        }
                }
                
                HStack(spacing: 12) {
                    Text("이름")
                    MyTextField(text: $food.name, isFinished: $isTypingFinished)
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
                    SelectionBar(selections: Category.casesStringArray(), selected: $food.category)
                    SelectionBar(selections: Category.fromRawValue(rawValue: food.category)!.getSubcategories(), selected: $food.subcategory)
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
                    SelectionBar(selections: Preservation.casesStringArray(), selected: $food.preservation)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 20)
            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundStyle(.lightBlue))
            .onChange(of: food.category) {
                food.subcategory = Category.fromRawValue(rawValue: food.category)?.getSubcategories().first ?? ""
            }
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
        @Binding var isFinished: Bool
        
        var body: some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 17)
                    .frame(height: 34)
                    .foregroundStyle(.white)
                
                RoundedRectangle(cornerRadius: 17)
                    .stroke(lineWidth: 1.5)
                    .frame(height: 34)
                    .foregroundStyle(.grey1)
                
                if text.isEmpty {
                    Text("식품 이름")
                        .padding(.leading, 15)
                        .opacity(0.5)
                }
                
                HStack {
                    ZStack(alignment: .leading) {
                        TextField("", text: $text) { startedEditing in
                            if startedEditing {
                                isFocused = true
                            }
                        } onCommit: {
                            isFocused = false
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
                                    UIApplication.shared.dismissKeyboard()
                                }
                            }
                            .padding(.trailing, 10)
                    }
                }
            }
            .foregroundStyle(.grey0)
            .font(.suite(.regular, size: 15))
            .onChange(of: isFocused) {
                isFinished = !isFocused
            }
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func addFood(data: TemporaryFood) {
        let newFood = Food(context: managedObjectContext)
        
        newFood.id = data.id
        newFood.name = data.name
        newFood.count = Int64(data.count)
        newFood.category = data.category
        newFood.subcategory = data.subcategory
        newFood.usebyDate = data.usebyDate
        newFood.preservation = data.preservation
        newFood.enrollDate = Date()
        
        saveContext()
    }
}
