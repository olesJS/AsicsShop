//
//  SheetView.swift
//  AsicsShop
//
//  Created by Олексій Якимчук on 25.07.2023.
//

import SwiftUI

extension View {
    func textFieldStyle() -> some View {
        modifier (TextFieldStyle())
    }
}

struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.darkBlueColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
    }
}

struct SheetView: View {
    @ObservedObject var order: Order
    
    @Environment(\.dismiss) var dismiss
    @State private var isOrderMessageActive = false
    @State private var confirmationMessage = ""
    @State private var quantity = 1
    
    let shoe: Shoe
    
    var body: some View {
        NavigationView {
            VStack {
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
                        Text("Price: \((shoe.price * Double(quantity)).formatted(.currency(code: "EUR")))")
                            .bold()
                        Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.darkBlueColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(3)
                
                Divider()
                    .padding(.horizontal)
                
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
                            await placeOrder()
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(!order.hasValidAddress)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.darkColor)
            .preferredColorScheme(.dark)
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
            .alert("Thank you!", isPresented: $isOrderMessageActive) {
                Button("OK") { }
            } message: {
                Text(confirmationMessage)
            }
        }
    }
    
    func placeOrder() async {
        order.name = shoe.name
        order.price = shoe.price
        order.quantity = quantity
        
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

            confirmationMessage = "\(decodedOrder.userName) ordered \(decodedOrder.quantity) pairs of ASICS \(decodedOrder.name). Total cost is: \(decodedOrder.cost.formatted(.currency(code: "EUR"))). Shipping address: \(decodedOrder.userAddress), \(decodedOrder.userCity)"
            isOrderMessageActive = true
        } catch {
            fatalError("Checkout failed")
        }
    }
}


struct SheetView_Previews: PreviewProvider {
    static var shoes = Bundle.main.decode("asics.json")
    
    static var previews: some View {
        SheetView(order: Order(), shoe: shoes[0])
    }
}
