//
//  ShoeView.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 24.07.2023.
//

import SwiftUI

struct ShoeView: View {
    @ObservedObject var order: Order
    @ObservedObject var orderItems: OrderItems
    
    @State private var isBuySheetPresented = false
    @State private var isCartAlertPresented = false
    
    let shoe: Shoe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: shoe.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(shoe.name)
                            .font(.largeTitle).bold()
                        Text(shoe.price.formatted(.currency(code: "EUR")))
                            .font(.title2)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Image("asicslogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .padding(.trailing)
                }
                .frame(maxWidth: .infinity, idealHeight: 90)
                .background(.midColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Divider()
                    .padding()
                
                Text(shoe.description)
                    .padding(.horizontal).font(.callout)
                
                Divider()
                    .padding(.horizontal)
                
                HStack(alignment: .center) {
                    Spacer()
                    
                    Button() {
                        isBuySheetPresented.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "basket")
                            Text("Buy now")
                        }
                        .padding()
                        .background(.midColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .sheet(isPresented: $isBuySheetPresented) {
                        SheetView(order: order, shoe: shoe)
                    }
                    
                    Button() {
                        orderItems.items.append(OrderItem(name: shoe.name, price: shoe.price, imageName: shoe.imageName))
                        print(orderItems.items)
                        isCartAlertPresented.toggle()
                    } label: {
                        Image(systemName: "cart.badge.plus")
                            .renderingMode(.template)
                            .foregroundColor(.blue)
                        Text("Add to cart")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(.midColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .alert("Asics \(shoe.name)'s been added to cart!", isPresented: $isCartAlertPresented) { }
                    
                    Spacer()
                }
            }
        }
        .navigationTitle(shoe.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkColor)
        .preferredColorScheme(.dark)
    }
}

struct ShoeView_Previews: PreviewProvider {
    static var shoes = Bundle.main.decode("asics.json")
    
    static var previews: some View {
        ShoeView(order: Order(), orderItems: OrderItems(), shoe: shoes[6])
    }
}
