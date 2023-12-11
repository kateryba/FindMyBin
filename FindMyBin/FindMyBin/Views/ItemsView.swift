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
    @State private var isAddPresented = false
    @State var searchString = ""

    var body: some View {
        NavigationStack {
            VStack() {
                TextField("Filter", text: $searchString)
            }
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
                    .accessibilityLabel("New Item")
                }
            }
            .sheet(isPresented: $isAddPresented) {
                ItemEditView(item: nil)
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView {
                        Label("No items yet", systemImage: "pawprint.circle")
                    } description: {
                        AddItemButton(isActive: $isAddPresented)
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
