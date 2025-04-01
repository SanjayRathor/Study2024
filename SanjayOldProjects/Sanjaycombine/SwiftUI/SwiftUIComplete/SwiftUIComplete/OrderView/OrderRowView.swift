//
//  OrderRowView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 18/11/20.
//

import SwiftUI

struct OrderRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: nil, content: {
            Text("Amount").bold()
            Spacer()
            Text("Rs.10")
        }).padding()
    }
}


struct OrderRowView_Previews: PreviewProvider {
    static var previews: some View {
        OrderRowView()
    }
}
