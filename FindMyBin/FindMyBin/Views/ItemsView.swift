//
//  ItemsView.swift
//  FindMyBin
//
//  
//
import SwiftUI
import SwiftData

struct ItemsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.name) private var items: [Item]
    @Query private var locations: [Location]
    @State private var isAddPresented = false
    @State var searchString = ""

    var body: some View {
        NavigationStack {
            TextField("Type in what you're looking for...", text: $searchString)
                .disableAutocorrection(true)
            List() {
                ForEach(searchString == "" ? items : items.filter { $0.name.localizedCaseInsensitiveContains(searchString) }) { item in
                    NavigationLink(item.name, value: item)
                }
                .onDelete(perform: removeItems)
            }
            .navigationDestination(for: Item.self) { item in
                ItemEditView(item: item)
            }
            .toolbar {
                ToolbarItem() {
                    Button(action: { self.isAddPresented = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem (placement: .navigationBarTrailing){
                    EditButton()
                }
            }
            .disabled(locations.isEmpty)
            .sheet(isPresented: $isAddPresented) {
                ItemEditView(item: nil)
            }
            .overlay {
                if items.isEmpty {
                    if locations.isEmpty
                    {
                        ContentUnavailableView {
                            Label("No locations yet. Add a location first", systemImage: "tray.2.fill")
                        }
                    }
                    else {
                        ContentUnavailableView {
                            Label("No items yet", systemImage: "pawprint.circle")
                        } description: {
                            AddItemButton(isActive: $isAddPresented)
                        }
                    }
                }
            }
        }
    }
    
    private func removeItems(at indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = items[index]
            modelContext.delete(itemToDelete)
        }
    }
}

private struct AddItemButton: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Add an item", systemImage: "plus")
                .help("Add an item")
        }
    }
}
