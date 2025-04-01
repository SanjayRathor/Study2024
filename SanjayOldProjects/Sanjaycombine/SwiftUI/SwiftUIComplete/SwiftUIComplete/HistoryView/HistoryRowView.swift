//
//  HistoryView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 19/11/20.
//

import SwiftUI

struct HistoryRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10, content: {
            Image("1_100w")
            Text("Hulli Chicken")
        })
    }
}

struct HistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRowView()
    }
}
