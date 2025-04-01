//
//  HistoryListView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 19/11/20.
//

import SwiftUI

struct HistoryListView: View {
    var body: some View {
        List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
            HistoryRowView()
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
    }
}
