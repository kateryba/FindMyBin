//
//  LocationView.swift
//  FindMyBin
//
//
//

import SwiftUI
import SwiftData

struct LocationView: View {
    let location: Location
    @Query private var items: [Item]
    @Query private var locations: [Location]
    @State var isEditPresented = false

    init(location: Location) {
        // let locationName = location.name
        // the second part doesn't work. It is always false. Like if this relationship is not loaded.
        // let predicate = #Predicate<Item> { $0.location != nil && $0.location!.name == locationName }
        self._items = Query(sort: \Item.name)
        self.location = location
    }
    
    var body: some View {
        VStack {
            Text("Items:")
            List(items) { item in if item.location?.name == location.name
                { Text(item.name) }
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
        }
    }
}
