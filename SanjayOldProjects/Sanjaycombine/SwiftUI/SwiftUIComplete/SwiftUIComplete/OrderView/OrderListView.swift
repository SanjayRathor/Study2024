//
//  OrderListView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 18/11/20.
//

import SwiftUI

struct OrderListView: View {
    var body: some View {
        VStack {
            Text("Your Order")
                .bold()
            List(0..<5) { item in
                OrderRowView()
            }
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}

