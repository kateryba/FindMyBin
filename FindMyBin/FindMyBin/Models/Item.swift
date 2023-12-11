//
//  Item.swift
//  FindMyBin
//
//
//

import SwiftData

@Model final class Item {
    @Attribute(.unique) var name: String
    var location: Location?
    
    init(name: String) {
        self.name = name
    }
}

