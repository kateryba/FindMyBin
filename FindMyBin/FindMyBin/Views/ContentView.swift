//
//  ContentView.swift
//  FindMyBin
//
//  Created by kateryna lutsyk on 2023-12-08.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationContext = NavigationContext()
    @Environment(\.modelContext) private var modelContext
    @Query private var locations: [Location]
    @State private var selection = 1
    
    var body: some View {
        TabView (selection:$selection) {
            ItemsView()
                .tabItem {
                    Label("Items", systemImage: "theatermasks")
                }
                .tag(1)
            LocationsView()
                .tabItem {
                    Label("Locations", systemImage: "tray.2.fill")
                }
                .tag(2)
        }
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
