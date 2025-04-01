//
//  SwiftUIViewTest.swift
//  SwitUIApp
//
//  Created by Sanjay Singh Rathor on 02/11/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import SwiftUI

struct SwiftUIViewTest: View {

    @State var name: String = ""
    @State var name1: Int = 12
    @Environment(\.locale) var locale: Locale
    
    var body: some View {
        TextField("Enter your name", text: $name) .multilineTextAlignment(.center)
        let jdh  = ScoreView(answered: $name1, of: 10)
       
    }
}

extension SwiftUIViewTest {
   
}


