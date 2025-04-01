//
//  MenuRowView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 18/11/20.
//

import SwiftUI

struct MenuRowView: View {
    
    var menuItem:MenuItem = testMenuItem
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10, content: {
                Image("\(menuItem.id)_100w")
                    .cornerRadius(5)
                    .shadow(radius: 5)
                VStack {
                    Text(menuItem.name)
                    RatingView()
                    
                }
               
            })
            Text(menuItem.description)
            Spacer()
        }
    }
}

struct MenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        MenuRowView()
    }
}
