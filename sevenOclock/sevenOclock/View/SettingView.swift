//
//  SettingView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/07.
//

import SwiftUI
import UserNotifications

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAlarmOn = false

    var body: some View {
        ZStack {
            Color.grey2.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(.white)
                        .frame(height: 48)
                    
                    Toggle("소비기한 임박 알림", isOn: $isAlarmOn)
                        .padding(.horizontal, 15)
                }
                
                Text("소비기한이 3일 미만 남은 식품에 대해 알림을 받습니다")
                    .foregroundStyle(.grey0)
                    .font(.suite(.regular, size: 13))
                    .padding(.top, 10)
                    .padding(.leading, 5)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(.white)
                        .frame(height: 48)
                    
                    HStack {
                        Text("라이센스")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.grey0)
                    }
                    .padding(.horizontal, 15)
                    .onTapGesture {
                        // TODO: Show license information
                    }
                }
                .padding(.top, 30)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(.white)
                        .frame(height: 48)
                    
                    HStack {
                        Text("개인정보 처리 방침")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.grey0)
                    }
                    .padding(.horizontal, 15)
                    .onTapGesture {
                        // TODO: Show privacy policy information
                    }
                }
                .padding(.top, 15)
                
                Spacer()
            }
            .font(.suite(.medium, size: 17))
            .padding(.horizontal, 20)
            .padding(.top, 25)
        }
        .onAppear {
            isAlarmOn = UserDefaults.standard.bool(forKey: "notificationEnabled")
        }
        .onChange(of: isAlarmOn) { newValue in
            if newValue {
                requestNotificationPermission()
            } else {
                UserDefaults.standard.set(newValue, forKey: "notificationEnabled")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        dismiss()
                    }
            }
            ToolbarItem(placement: .principal) {
                Text("설정")
                    .font(.suite(.semibold, size: 17))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("알림 권한이 허용되었습니다.")
                UserDefaults.standard.set(true, forKey: "notificationEnabled")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    SettingView()
}
