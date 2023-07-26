//
//  OrderItems.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 25.07.2023.
//

import Foundation

class OrderItems: ObservableObject {
    @Published var items = [OrderItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Shoes")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Shoes") {
            if let decodedItems = try? JSONDecoder().decode([OrderItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}
