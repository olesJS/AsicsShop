//
//  Shoe.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 23.07.2023.
//

import Foundation

struct Shoe: Codable, Identifiable {
    let name: String
    let price: Double
    let colors: Int
    let description: String
    let imageName: String
    
    var id = UUID()
    
    var imageURL: URL {
        URL(string: imageName)!
    }
    
    private enum CodingKeys : String, CodingKey { case name, price, colors, description, imageName }
}
