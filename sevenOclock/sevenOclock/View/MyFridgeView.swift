//
//  MyFridgeView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/26.
//

import SwiftUI
import CarBode
import AVFoundation
import AlertToast

struct MyFridgeView: View {
    init? () {
        let scenes = UIApplication.shared.connectedScenes
        guard let scene = scenes.first as? UIWindowScene else { return nil }
        scene.keyWindow?.overrideUserInterfaceStyle = .light
    }
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(entity: Food.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Food.usebyDate, ascending: true)]) var foods: FetchedResults<Food>
    @StateObject var receiptViewModel = ReceiptViewModel()
    
    private let maxAPICallsPerDay = 2
    
    @State var isShowingAddedToast = false
    @State var isShowingCountUpdatedToast = false
    @State var isShowingDeletedToast = false
    @State var isShowingCountInputErrorToast = false
    @State var isShowingOCRErrorToast = false
    @State var isShowingOCRLimitToast = false
    @State var isShowingBarcodeErrorToast = false
    
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
    @State var isShowingScanner = false
    
    @State private var image: UIImage?
    @State var isShowingCameraSheet = false
    
    @State var selectedFood: Food?
    @State var isShowingAlert = false
    @State var inputText = ""
    
    @State private var updatedObject: Food?
    
    @State var temporaryFoodList: [TemporaryFood] = []
    
    @State var isShowingReceiptSheet = false
    
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
                
                if foods.count > 0 {
                    FoodGridView(foods: filteredFoods, backgroundColour: Color.blue, preservation: selectedPreservation, isShowingAlert: $isShowingAlert, inputText: $inputText, selectedFood: $selectedFood)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 15)
                } else {
                    HStack {
                        Spacer()
                        Text("저장된 식품이 없습니다.")
                            .font(.suite(.semibold, size: 20))
                            .padding(.top, 100)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .confirmationDialog("Add", isPresented: $isShowingAddConfirmation) {
                Button("영수증 촬영") {
                    isShowingCameraSheet.toggle()
                }
                Button("바코드 인식") {
                    isShowingScanner.toggle()
                }
                Button("직접 입력") {
                    Task {
                        temporaryFoodList = []
                        isShowingAddSheet.toggle()
                    }
                }
                Button("취소", role: .cancel) { }
            } message: {
                Text("어떻게 냉장고에 추가하실 건가요?")
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddFoodView(foodList: $temporaryFoodList)
            }
            .sheet(isPresented: $isShowingCameraSheet) {
                ImagePicker(sourceType: .camera, selectedImage: self.$image)
            }
            .sheet(isPresented: $isShowingScanner) {
                NavigationView {
                    CBScanner(
                        supportBarcode: .constant([.qr, .ean13]),
                        scanInterval: .constant(5.0)
                    ){
                        isShowingScanner = false
                        fetchBarcodeData(barcodeNumber: $0.value)
                    } onDraw: {
                        $0.draw(lineWidth: 2, lineColor: UIColor.orange, fillColor: UIColor(red: 0, green: 0, blue: 0.2, alpha: 0.4))
                    }
                    .navigationBarItems(trailing: Button("닫기") {
                        isShowingScanner = false
                    })
                }
            }
            .sheet(isPresented: $isShowingReceiptSheet) {
                CheckItemView(items: receiptViewModel.items, foodList: $temporaryFoodList, isShowingAddSheet: $isShowingAddSheet)
            }
            .alert("꺼낼 \(selectedFood?.name ?? "") 수량을 입력해 주세요.", isPresented: $isShowingAlert) {
                TextField("", text: $inputText)
                    .keyboardType(.decimalPad)
                    .autocorrectionDisabled()
                    
                Button("확인", action: {
                    if let count = Int(inputText) {
                        if let object = foods.first(where: { $0.id == selectedFood?.id }) {
                            if count >= object.count {
                                // Delete
                                managedObjectContext.delete(object)
                                saveContext()
                                isShowingDeletedToast.toggle()
                            } else {
                                // Update count property
                                object.count -= Int64(count)
                                updateFood(data: object)
                                isShowingCountUpdatedToast.toggle()
                            }
                        }
                    } else {
                        isShowingCountInputErrorToast.toggle()
                    }
                })
                Button("취소", role: .cancel, action: {})
            }
            .toast(isPresenting: $isShowingAddedToast){
                AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: "식품이 추가되었습니다.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
            }
            .toast(isPresenting: $isShowingDeletedToast){
                AlertToast(displayMode: .banner(.slide), type: .regular, title: "식품이 삭제되었습니다.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
            }
            .toast(isPresenting: $isShowingCountUpdatedToast){
                AlertToast(displayMode: .banner(.slide), type: .regular, title: "식품 수량이 수정되었습니다.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
            }
            .toast(isPresenting: $isShowingCountInputErrorToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "잘못된 입력입니다", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
            }
            .toast(isPresenting: $isShowingOCRLimitToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "영수증 입력 일일 호출 횟수를 초과했습니다.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
            }
            .toast(isPresenting: $isShowingBarcodeErrorToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "해당하는 데이터가 없습니다.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
            }
            .toast(isPresenting: $isShowingOCRErrorToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "영수증 인식에 실패했습니다.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
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
        .onAppear {
            receiptViewModel.items = []
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                if UserDefaults.standard.bool(forKey: "notificationEnabled") {
                    scheduleNotification()
                }
            }
        }
        .onChange(of: image) {
            if canMakeAPICall() {
                fetchReceiptData()
            } else {
                print("API 호출 한도 초과")
                isShowingOCRLimitToast.toggle()
            }
        }
        .onChange(of: receiptViewModel.items.count) {
            if(receiptViewModel.items.count != 0) {
                isShowingReceiptSheet.toggle()
            }
        }
        .onChange(of: foods.count) { oldValue, newValue in
            if oldValue < newValue {
                isShowingAddedToast.toggle()
            }
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
    
    private func scheduleNotification() {
        let urgentFoods = foods.filter { $0.usebyDate?.daysLeft() ?? 999 <= 3 }
        if let oldest = urgentFoods.first {
            let content = UNMutableNotificationContent()
            content.title = "소비기한 알림"
            content.body = oldest.usebyDate!.daysLeft() < 0 ? "\(oldest.name ?? "식품")의 소비기한이 지났습니다." : "\(oldest.name ?? "식품")의 소비기한이 임박했습니다."
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 7
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func fetchReceiptData() {
//        if let url = Bundle.main.url(forResource: "dummydata", withExtension: "json"),
//           let jsonData = try? Data(contentsOf: url) {
//            receiptViewModel.parseReceiptResponse(jsonData: jsonData)
//        }
        incrementAPICallCount()
        
        if let image = image, let data = image.pngData(), let url = URL(string: APIKey.receiptURL) {
            let base64 = data.base64EncodedString()
            let naver = Naver(version: "V2", requestID: APIKey.receiptKey, timestamp: 0, images: [NaverImage(format: "png", name: UUID().uuidString, data: base64)] )
            
            let encoder = JSONEncoder()
            
            let jsonData = try? encoder.encode(naver)
            let jsonString = String(bytes: jsonData!, encoding: .utf8)

            if let requestBody = jsonString {
                //URLRequest 생성
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue(APIKey.receiptKey, forHTTPHeaderField: "X-OCR-SECRET")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = requestBody.data(using: .utf8)
                
                URLSession.shared.dataTask(with: request) {
                    (data, response, error) in
                    if let error = error {
                        print("Request error: ", error)
                        isShowingOCRErrorToast.toggle()
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        isShowingOCRErrorToast.toggle()
                        return
                    }
                    
                    if response.statusCode == 200 {
                        guard let data = data else {
                            isShowingOCRErrorToast.toggle()
                            return
                        }
                        DispatchQueue.main.async {
                            receiptViewModel.parseReceiptResponse(jsonData: data)
                        }
                    }
                }.resume()
            }
        }
    }
    
    private func canMakeAPICall() -> Bool {
        let currentDate = Date()
        let lastCallDate = UserDefaults.standard.object(forKey: "lastAPICallDate") as? Date ?? Date.distantPast
        let callCount = UserDefaults.standard.integer(forKey: "dailyAPICallCount")
        
        if Calendar.current.isDate(currentDate, inSameDayAs: lastCallDate) {
            return callCount < maxAPICallsPerDay
        } else {
            UserDefaults.standard.set(0, forKey: "dailyAPICallCount")
            UserDefaults.standard.set(currentDate, forKey: "lastAPICallDate")
            return true
        }
    }
    
    private func incrementAPICallCount() {
        let currentCount = UserDefaults.standard.integer(forKey: "dailyAPICallCount")
        UserDefaults.standard.set(currentCount + 1, forKey: "dailyAPICallCount")
    }

    func fetchBarcodeData(barcodeNumber: String) {
        if let url = URL(string: "http://openapi.foodsafetykorea.go.kr/api/\(APIKey.barcodeKey)/C005/json/1/5/BAR_CD=\(barcodeNumber)") {
            let request = URLRequest.init(url: url)
            
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in guard let data = data else {return}
                let decoder = JSONDecoder()
                do {
                    let json = try decoder.decode(FoodDataModel.self , from: data)
                    if let row = json.C005.row {
                        Task {
                            temporaryFoodList.append(TemporaryFood(id: UUID(), name: row.first?.PRDLST_NM ?? ""))
                            print(temporaryFoodList.count)
                            isShowingAddSheet.toggle()
                        }
                    } else {
                        isShowingBarcodeErrorToast.toggle()
                    }
                }
                catch {
                    isShowingBarcodeErrorToast.toggle()
                    print(error)
                }
            }.resume()
        }
    }
}

#Preview {
    MyFridgeView()
}
