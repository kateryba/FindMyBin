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
    
    @State private var originalName = ""
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
                        if name == "" {
                            errorMessage = ""
                            isNameAvailableValue = false
                        }
                        else {
                            isNameAvailableValue = isNameAvailable(for: name, in: modelContext)
                            errorMessage = isNameAvailableValue ? "" : "This name is already in use"
                        }
                    }
            }
            .onAppear {
                if let location {
                    // Edit the incoming location.
                    name = location.name
                    originalName = location.name
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
    
    func isNameAvailable(for newName: String, in modelContext: ModelContext) -> Bool {
        if newName == originalName {
            return true
        }
        
        let predicate = #Predicate<Location> { $0.name == newName }
        let fetchDescriptor = FetchDescriptor<Location>(predicate: predicate)

        var res = false
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
