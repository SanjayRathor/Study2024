//
//  MenuListView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 18/11/20.
//

import SwiftUI

struct MenuListView: View {
    
    var menuList = MenuModel().menu
    var body: some View {
        VStack {
            Text("Menu")
            NavigationView {
                List(menuList) { item in
                    NavigationLink(
                        destination: MenuDetailView(menuItem:item)) {
                        MenuRowView(menuItem: item)
                            
                    }
                }.listRowInsets(EdgeInsets())
                .padding()
                .navigationTitle("dasdasdff")
            }
            
        }
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuListView()
    }
}
