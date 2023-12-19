//
//  ContentView.swift
//  FindMyBin
//
//
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var locations: [Location]
    
    var body: some View {
        TabView {
            ItemsView()
                .tabItem {
                    Label("Items", systemImage: "theatermasks")
                }
            LocationsView()
                .tabItem {
                    Label("Locations", systemImage: "tray.2.fill")
                }
        }
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
