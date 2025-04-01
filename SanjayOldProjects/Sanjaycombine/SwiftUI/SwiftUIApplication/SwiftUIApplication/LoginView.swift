//
//  LoginView.swift
//  SwiftUIApplication
//
//  Created by Sanjay Singh Rathor on 10/11/20.
//

import SwiftUI

struct LoginView: View {
    @State var userName:String = ""
    @State var password:String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("LOGIN")
                    .bold()
                
                TextField("Your Name", text: $userName)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .background(Color.clear)
                    .padding()
                
                TextField("Password", text: $password)
                    .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .background(Color.clear)
                    .padding()
                
                Button("Login") {
                    print("Name \(userName)")
                }
            }.navigationTitle("Login View")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
