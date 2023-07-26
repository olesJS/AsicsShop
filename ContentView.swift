//
//  ContentView.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 23.07.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = Order()
    @StateObject var orderItems = OrderItems()
    
    let shoes = Bundle.main.decode("asics.json")
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(shoes) { shoe in
                        NavigationLink {
                            ShoeView(order: order, orderItems: orderItems, shoe: shoe)
                        } label: {
                            VStack {
                                AsyncImage(url: shoe.imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 155, height: 140)
                                }
                                .frame(width: 175)
                                
                                VStack {
                                    Text(shoe.name)
                                        .foregroundColor(.whiteColor)
                                        .font(.title3).bold()
                                    Text(shoe.price.formatted(.currency(code: "EUR")))
                                        .foregroundColor(.whiteColor)
                                        .font(.callout.bold())
                                }
                                .frame(width: 175, height: 50)
                                .padding(.vertical)
                                .background(.midColor)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .frame(width: 175, height: 220)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(.darkBlueColor, lineWidth: 3)
                            )
                        }
                    }
                }
            }
            .navigationBarTitle("ASICS")
            .background(.darkColor)
            .preferredColorScheme(.dark)
            .toolbar {
                NavigationLink {
                    CartView(orderItems: orderItems)
                } label: {
                    Image(systemName: "cart")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
