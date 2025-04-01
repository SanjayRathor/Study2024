//
//  MenuDeatilsView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 21/11/20.
//

import SwiftUI

import SwiftUI
///A `View`for entering in an order. Takes basic information about the order from `menuItem`
struct MenuDetailView: View {
    var menuItem:MenuItem
    var formattedPrice:String{
        String(format:"%3.2f",menuItem.price)
    }
    func addItem(){
    }
    
    var body: some View {
        VStack {
            PageTitleView()
         
            
            Text(menuItem.description)
                .lineLimit(5)
                .padding()
                .layoutPriority(3)
                
            Spacer()
            HStack{
                Spacer()
                Text("Pizza size")
                Text("Small")
            }
            .font(.headline)
            HStack{
                Text("Quantity:")
                Text("1")
                    .bold()
                Spacer()
            }
            .padding()
            HStack{
                Text("Order:  \(formattedPrice)")
                    .font(.headline)
                Spacer()
                Text("Order total: \(formattedPrice)" )
                    .font(.headline)
            }
            .padding()
            HStack{
                Spacer()
                Button(action: addItem) {
                   Text("Add to order")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    .background(Color("G4"))
                        .foregroundColor(Color("IP"))
                        .cornerRadius(5)
                }
                Spacer()
            }
            .padding(.top)
            Spacer()
        }
        
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailView(menuItem: testMenuItem)
    }
}
