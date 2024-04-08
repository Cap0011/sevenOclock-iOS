//
//  sevenOclockApp.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/25.
//

import SwiftUI

@main
struct sevenOclockApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
        }
    }
}
