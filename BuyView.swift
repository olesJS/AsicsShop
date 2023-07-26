//
//  BuyView.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 26.07.2023.
//

import SwiftUI

struct BuyView: View {
    @ObservedObject var orderItems: OrderItems
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var isOrderMessageActive = false
    
    let totalPrice: Double
    
    var itemsNames: [String] {
        var array: [String] = []
        for item in orderItems.items {
            array.append(item.name)
        }
        return array
    }
    
    var body: some View {
        VStack {
            TextField("Name", text: $order.userName)
                .textFieldStyle()
            TextField("City", text: $order.userCity)
                .textFieldStyle()
            TextField("Address", text: $order.userAddress)
                .textFieldStyle()
            TextField("Telephone number", text: $order.userNumber)
                .textFieldStyle()
            
            Button("Place order") {
                Task {
                    isOrderMessageActive.toggle()
                    await placeOrder()
                }
            }
            .buttonStyle(.bordered)
            .disabled(!order.hasValidAddress)
            .alert("Thank you!", isPresented: $isOrderMessageActive) {
                Button("OK") { }
            } message: {
                Text(confirmationMessage)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Buy")
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkColor)
    }
    
    func placeOrder() async {
        order.name = ""
        order.price = totalPrice
        order.quantity = 1
        
        guard let encoded = try? JSONEncoder().encode(order) else {
            fatalError("Failed to encode order")
        }
        
        let url = URL(string: "https://reqres.in/api/asics")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)

            confirmationMessage = "\(decodedOrder.userName) ordered \(itemsNames.formatted()). Total cost is: \(decodedOrder.cost.formatted(.currency(code: "EUR"))). Shipping address: \(decodedOrder.userAddress), \(decodedOrder.userCity)"
            isOrderMessageActive = true
        } catch {
            fatalError("Checkout failed")
        }
    }
}

struct BuyView_Previews: PreviewProvider {
    static var previews: some View {
        BuyView(orderItems: OrderItems(), order: Order(), totalPrice: 100.0)
    }
}
