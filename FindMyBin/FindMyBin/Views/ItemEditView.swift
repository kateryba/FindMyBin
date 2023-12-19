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
    
    @State private var name = ""
    @State private var selectedLocation: Location?
    @State private var errorMessage = ""
    @State private var isNameAvailableValue = true
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Location.name) private var locations: [Location]
    
    var body: some View {
        VStack {
            /*Label(errorMessage, systemImage: "heart")
                .foregroundColor(.red)
                .labelStyle(.titleOnly)*/
            Text(item == nil ? "Add item" : "Edit item")
            Form {
                TextField("Name", text: $name)
                    .onChange(of: name) {
                        isNameAvailableValue = isNameAvailable(for: name, in: modelContext)
                        errorMessage = isNameAvailableValue ? "" : "This name is already in use"
                    }
                    .disableAutocorrection(true)
                
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
            .disabled($selectedLocation.wrappedValue == nil || !isNameAvailableValue)

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
    
    func isNameAvailable(for name: String, in modelContext: ModelContext) -> Bool {
        let predicate = #Predicate<Item> { $0.name == name }
        let fetchDescriptor = FetchDescriptor<Item>(predicate: predicate)

        var res = name != ""
        do {
            try res = modelContext.fetchCount(fetchDescriptor) == 0
        }
        catch {
        }
        return res;
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
