//
//  db_library_swiftApp.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/4.
//

import SwiftUI

@main
struct db_library_swiftApp: App {
    
    var loginManager = LoginManager()
    var sharedModel = SharedModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(loginManager)
                .environmentObject(sharedModel)
        }
    }
}
