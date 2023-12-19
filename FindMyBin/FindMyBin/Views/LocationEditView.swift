//
//  LocationEditView.swift
//  FindMyBin
//
//
//

import SwiftUI
import SwiftData

struct LocationEditView: View {
    let location: Location?
    
    @State private var name = ""
    @State private var errorMessage = ""
    @State private var isNameAvailableValue = true
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            Label(errorMessage, systemImage: "heart")
                .foregroundColor(.red)
                .labelStyle(.titleOnly)

            Text(location == nil ? "Add location" : "Edit location")
            Form {
                TextField("Name", text: $name)
                    .onChange(of: name) {
                        isNameAvailableValue = isNameAvailable(for: name, in: modelContext)
                        errorMessage = isNameAvailableValue ? "" : "This name is already in use"
                    }
            }
            .onAppear {
                if let location {
                    // Edit the incoming location.
                    name = location.name
                }
            }
            
            Button("Save") {
                withAnimation {
                    save()
                    dismiss()
                }
            }
            // Require a name to save changes.
            .disabled(name == "" || !isNameAvailableValue)
            
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
    }
    
    func isNameAvailable(for name: String, in modelContext: ModelContext) -> Bool {
        let predicate = #Predicate<Location> { $0.name == name }
        let fetchDescriptor = FetchDescriptor<Location>(predicate: predicate)

        var res = name != ""
        do {
            try res = modelContext.fetchCount(fetchDescriptor) == 0
        }
        catch {
        }
        return res;
    }
    
    private func save() {
        if let location {
            // Edit the location.
            location.name = name
        } else {
            // Add a location.
            let newLocation = Location(name: name)
            modelContext.insert(newLocation)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    let location = Location(name: "Test Location")
    return LocationEditView(location: location).modelContainer(container)
}
