//
//  RatingView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 18/11/20.
//

import SwiftUI

struct RatingView: View {
    var body: some View {
        HStack {
            ForEach(0..<4) { item in
                Image("Pizza Slice")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .top)
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
