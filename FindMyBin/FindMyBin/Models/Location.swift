//
//  Location.swift
//  FindMyBin
//
//  
//
import SwiftData

@Model
final class Location {
    @Attribute var name: String
    @Relationship(deleteRule: .deny, inverse: \Item.location)
    var items = [Item]()
    
    
    init(name: String) {
        self.name = name
    }
}
