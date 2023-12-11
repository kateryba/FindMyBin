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
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $name)
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
            .disabled(name == "")
            
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
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
