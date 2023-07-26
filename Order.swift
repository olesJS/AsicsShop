//
//  Order.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 25.07.2023.
//

import Foundation

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case name, price, quantity, totalPrice, userName, userCity, userAddress, userNumber
    }
    
    // Order details
    @Published var name = ""
    @Published var price = 1.00
    @Published var quantity = 1
    
    // Delivery details
    @Published var userName = ""
    @Published var userCity = ""
    @Published var userAddress = ""
    @Published var userNumber = ""
    
    var cost: Double {
        return price * Double(quantity)
    }
    
    var hasValidAddress: Bool {
        if userName.replacingOccurrences(of: " ", with: "") == "" || userAddress.replacingOccurrences(of: " ", with: "") == "" || userCity.replacingOccurrences(of: " ", with: "") == "" || userNumber.replacingOccurrences(of: " ", with: "") == "" {
            return false
        }
        
        if userName.count <= 2 || userCity.count <= 2 || userAddress.count <= 5 || userNumber.count < 10 {
            return false
        }
        
        for char in userName {
            if char.isNumber { return false }
        }
        
        for char in userNumber {
            if char.isLetter { return false }
        }
        
        return true
    }
    
    init() { }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(userName, forKey: .userName)
        try container.encode(userCity, forKey: .userCity)
        try container.encode(userAddress, forKey: .userAddress)
        try container.encode(userNumber, forKey: .userNumber)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        userName = try container.decode(String.self, forKey: .userName)
        userCity = try container.decode(String.self, forKey: .userCity)
        userAddress = try container.decode(String.self, forKey: .userAddress)
        userNumber = try container.decode(String.self, forKey: .userNumber)
    }
}
