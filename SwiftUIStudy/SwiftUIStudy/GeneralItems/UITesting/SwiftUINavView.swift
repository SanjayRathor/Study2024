//
//  SwiftUINavView.swift
//  StudySwiftUI
//
//  Created by Sanjay Rathor on 27/03/25.
//

import SwiftUI

struct SwiftUINavView: View {
    /*  @State private var name = ""
     @State private var address = ""
     
     var body: some View {
     Text("Render the effects for a group of views before applying more effects to it.")
     VStack(spacing: 30) {
     TextField("Name", text: $name)
     .padding().background(Color.white).cornerRadius(15)
     .shadow(radius: 5)
     TextField("Address", text: $address)
     .padding().background(Color.white).cornerRadius(15)
     .shadow(radius: 5)
     Button(action: {}) {
     HStack {
     Text("Next")
     Image(systemName: "chevron.right")
     }.padding()
     }
     .padding(.horizontal).foregroundColor(.white)
     .background(Color.blue).cornerRadius(15)
     .shadow(radius: 5)
     }
     .compositingGroup() // Apply effect modifiers
     .padding(20)
     .background(Color.green.opacity(0.9))
     .cornerRadius(20)
     .shadow(radius: 5)
     .padding(20)
     Text("If you remove the .compositingGroup() modifier, you will notice you can't tap inside the TextFields.")
     }
     */
    
    @State private var likes = 0
    var body: some View {
        VStack(spacing: 20) {
            Text("Content Shape").font(.largeTitle)
            Text("Solution").foregroundColor(.gray)
            Text("To fix this, you could add a solid color RoundedRectangle as a background hape. But if you don't want to do that, then add a contentShape modifier.")
                .frame(maxWidth: .infinity)
                .padding().foregroundColor(.white)
                .background(Color.pink)
            VStack(spacing: 20) {
                Image(systemName: likes > 0 ? "heart.fill" : "heart")
                    .foregroundColor(likes > 0 ? .red : .gray)
                    .frame(width: 100, height: 100)
                Text("Hit me! (Likes: \(likes))")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).stroke(Color.red, lineWidth: 1))
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture {
                self.likes = self.likes + 1
            }
        }
        .font(.title)
    }
}

#Preview {
    SwiftUINavView()
}
