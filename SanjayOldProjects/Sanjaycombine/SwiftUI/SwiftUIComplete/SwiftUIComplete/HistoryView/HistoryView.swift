//
//  HistoryView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 20/11/20.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack {
            ContentHeaderView(title: "")
            PageTitleView()
            HistoryListView()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
