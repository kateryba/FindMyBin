//
//  LocationView.swift
//  finalproj_ui
//
//
//

import SwiftUI
import SwiftData

struct LocationView: View {
    let location: Location
    @Query private var items: [Item]
    @State var isEditPresented = false

    init(location: Location) {
        let locationName = location.name
        let predicate = #Predicate<Item> { $0.location != nil && $0.location!.name == locationName }// the second part doesn't work. It is always false. Like if this relationship is not loaded.
        self._items = Query(filter: predicate, sort: \Item.name)
        self.location = location
    }
    
    var body: some View {
        VStack {
            Text("Items:")
            List(items) { item in
                Text(item.name)
            }
        }
        .navigationTitle(location.name)
        .sheet(isPresented: $isEditPresented) {
            LocationEditView(location: location)
        }
        .toolbar {
            Button("Edit") {
                self.isEditPresented = true
            }
            .accessibilityLabel("Edit Location")
        }
    }
}
