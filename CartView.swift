//
//  CartView.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 25.07.2023.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var orderItems: OrderItems
    @ObservedObject var order = Order()
    var totalPrice: Double {
        var number: Double = 0.0
        for item in orderItems.items {
            number += (item.price * Double(item.quantity))
        }
        return number
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(orderItems.items) { shoe in
                    HStack {
                        AsyncImage(url: shoe.imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment: .leading) {
                            Text(shoe.name)
                                .foregroundColor(.midColor).font(.title2).bold()
                            Text("Price: \((shoe.price * Double(shoe.quantity)).formatted(.currency(code: "EUR")))")
                                .bold()
                            Stepper("Quantity: \(shoe.quantity)", value: $orderItems.items[orderItems.items.firstIndex(of: shoe)!].quantity, in: 1...10)
                                .frame(height: 8)
                            Button("Delete", role: .destructive) {
                                orderItems.items.remove(at: orderItems.items.firstIndex(of: shoe)!)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.darkBlueColor)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(3)
                }
                
                
            }
            .frame(maxWidth: .infinity)
            
            
            Spacer()
            
            Text("Total price: \(totalPrice.formatted(.currency(code: "EUR")))")
                .bold()
            
            HStack {
                NavigationLink {
                    BuyView(orderItems: orderItems, order: order, totalPrice: totalPrice)
                } label: {
                    Text("Buy \(Image(systemName: "bag"))")
                        .padding(10)
                        .background(.midColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Button("Delete all \(Image(systemName: "trash"))", role: .destructive) {
                    orderItems.items.removeAll()
                }
                    .padding(10)
                    .background(.midColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(totalPrice == 0)
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkColor)
        .preferredColorScheme(.dark)
    }
}

struct CartView_Previews: PreviewProvider {
    static var orderItems = OrderItems()
    static var shoes = Bundle.main.decode("asics.json")
    static var shoe1 = shoes[1]
    
    static var previews: some View {
        CartView(orderItems: OrderItems(), order: Order())
    }
}
