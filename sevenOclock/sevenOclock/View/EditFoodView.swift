//
//  EditFoodView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 5/18/25.
//

import SwiftUI
import AlertToast

struct EditFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let food: Food?
    @State private var isShowingToast = false
    
    @State private var temporaryFood = TemporaryFood(id: UUID())
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                FoodInputCard(food: temporaryFood)
                    .font(.suite(.bold, size: 15))
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Spacer()
            }
            .padding(.vertical, 25)
            .toast(isPresenting: $isShowingToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "식품 이름을 입력해주세요.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
            }
            .task {
                if let food = food {
                    temporaryFood.name = food.name ?? ""
                    temporaryFood.count = Int(food.count)
                    temporaryFood.category = food.category ?? "육류"
                    temporaryFood.subcategory = food.subcategory ?? "소고기"
                    temporaryFood.usebyDate = food.usebyDate ?? Date()
                    temporaryFood.preservation = food.preservation ?? "냉장"
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("취소")
                        .font(.suite(.regular, size: 16))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("식품 수정")
                        .font(.suite(.semibold, size: 17))
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("완료")
                        .font(.suite(.bold, size: 16))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if temporaryFood.name == "" {
                                isShowingToast.toggle()
                            } else {
                                updateFood(data: temporaryFood)
                                dismiss()
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }

    private func updateFood(data: TemporaryFood) {
        if let food = food {
            let newFood = Food(context: managedObjectContext)
            newFood.id = food.id
            newFood.name = data.name
            newFood.count = Int64(data.count)
            newFood.category = data.category
            newFood.subcategory = data.subcategory
            newFood.usebyDate = data.usebyDate
            newFood.preservation = data.preservation
            newFood.enrollDate = food.enrollDate
            
            managedObjectContext.delete(food)
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    struct FoodInputCard: View {
        @StateObject var food: TemporaryFood
        
        @State var isTypingFinished = true

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
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
}
