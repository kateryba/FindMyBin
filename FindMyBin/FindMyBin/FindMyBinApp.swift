//
//  FindMyBinApp.swift
//  FindMyBin
//
//  
//

import SwiftUI
import SwiftData

@main
struct finalproj_uiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Location.self, Item.self])
    }
}
