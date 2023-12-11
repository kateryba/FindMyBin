//
//  NavigationContent.swift
//  FindMyBin
//
// 
//

import SwiftUI

@Observable
class NavigationContext {
    var selectedItemLocationName: String?
    var selectedItem: Item?
    
    init(selectedItemLocationName: String? = nil, selectedItem: Item? = nil) {
        self.selectedItemLocationName = selectedItemLocationName
        self.selectedItem = selectedItem
    }
}
