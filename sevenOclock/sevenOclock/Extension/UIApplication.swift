//
//  UIApplication.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/26.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
