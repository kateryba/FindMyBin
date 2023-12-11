//
//  ItemEditView.swift
//  FindMyBin
//
//  
//

import SwiftUI
import SwiftData

struct ItemEditView: View {
    let item: Item?
    
    private var editorTitle: String {
        item == nil ? "Add item" : "Edit item";
    }
    
    @State private var name = ""
    @State private var selectedLocation: Location?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Location.name) private var locations: [Location]
    
    var body: some View {
        VStack {
            Text(editorTitle)

            Form {
                TextField("Name", text: $name)
                
                Picker("Location", selection: $selectedLocation) {
                    Text("Select a location").tag(nil as Location?)
                    ForEach(locations) { location in
                        Text(location.name).tag(location as Location?)
                    }
                }
            }

            Button("Save") {
                withAnimation {
                    save()
                    dismiss()
                }
            }
            // Require a location to save changes.
            .disabled($selectedLocation.wrappedValue == nil)

            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
        .onAppear {
            if let item {
                // Edit the incoming item.
                name = item.name
                selectedLocation = item.location
            }
        }
    }
    
    private func save() {
        if let item {
            // Edit the item.
            item.name = name
            item.location = selectedLocation
        } else {
            // Add an item.
            let newItem = Item(name: name)
            newItem.location = selectedLocation
            modelContext.insert(newItem)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Item.self, configurations: config)
    
    let location = Location(name: "Test Location")
    let item = Item(name: "Test Item")
    item.location = location
    return ItemEditView(item: item).modelContainer(container)
}
