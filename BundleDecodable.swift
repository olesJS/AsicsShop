//
//  BundleDecodable.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 23.07.2023.
//

import Foundation

extension Bundle {
    func decode(_ file: String) -> [Shoe] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file). URL Error")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to find data. Data Error")
        }
        
        let decoder = JSONDecoder()
        
        do {
            let loaded = try decoder.decode([Shoe].self, from: data)
            return loaded
        } catch {
            fatalError("Decode Fatal Error. Failed to decode \(file). Error: \(error)")
        }

    }
}
