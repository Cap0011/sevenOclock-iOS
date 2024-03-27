//
//  sevenOclockApp.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/25.
//

import SwiftUI

@main
struct sevenOclockApp: App {
    var body: some Scene {
        WindowGroup {
            MyFridgeView()
                .preferredColorScheme(.light)
        }
    }
}
