//
//  ContentView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 17/11/20.
//

import SwiftUI

struct ContentView: View {
    var pizza = 0
    @EnvironmentObject var user: User
    @State var pizzaString = "asdlajsdl"
    var body: some View {
        HStack {
         Text("A great and warm welcome to Kuchi hhia sda sdhiadisiasdi knakdnkanskdnkasdknadslk")
//            .background(Color.red).layoutPriority(1)
//            Text("A great and warm welcome to Kuchi")
//            .background(Color.red)
            
            Form {
                Text("A great and warm welcome to Kuchi")
            }
        }
        .background(Color.yellow)
        
        
        
        
        /*
        Text(user.name)
        StatesUIView(myname: $pizzaString)
   
        VStack {
            ContentHeaderView(title: "Contents Header")
            MenuListView().layoutPriority(1.1)
            OrderListView().layoutPriority(1)
            Spacer()
            
        }.padding()
 */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .colorScheme(.dark)
            .background(Color.black)
        
    }
}
