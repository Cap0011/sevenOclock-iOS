//
//  MyTextField.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 5/18/25.
//

import SwiftUI

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
