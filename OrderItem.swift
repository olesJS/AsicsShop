//
//  OrderItem.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 25.07.2023.
//

import Foundation

struct OrderItem: Codable, Identifiable, Equatable {
    let name: String
    let price: Double
    let imageName: String
    
    var quantity = 1
    
    var imageURL: URL {
        URL(string: imageName)!
    }
    
    var id = UUID()
}
