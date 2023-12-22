//
//  LocationsView.swift
//  FindMyBin
//
//  
//

import SwiftUI
import SwiftData

struct LocationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Location.name) private var locations: [Location]
    @State var isAddPresented = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(locations) { location in
                    NavigationLink(destination: LocationView(location: location)) {
                        Text(location.name)
                    }
                }
                .onDelete(perform: removeLocations)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: { self.isAddPresented = true }) {
                        Image(systemName: "plus")
                    }
                }
                
            }
        }
        .sheet(isPresented: $isAddPresented) {
            LocationEditView(location: nil)
        }
    }
    
    private func removeLocations(indexSet: IndexSet) {
        for index in indexSet {
            let locationToDelete = locations[index]
            if locationToDelete.items.isEmpty{
                modelContext.delete(locationToDelete)
            }
        }
    }
}



@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Location.self, configurations: config)

            for i in 1...9 {
                let location = Location(name: "Example Location \(i)")
                container.mainContext.insert(location)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .frame(minWidth: 500, minHeight: 500)
            .modelContainer(DataController.previewContainer)
    }
}
