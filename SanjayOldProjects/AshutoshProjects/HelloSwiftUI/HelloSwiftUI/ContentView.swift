//
//  ContentView.swift
//  HelloSwiftUI
//
//  Created by Sanjay Singh Rathor on 23/02/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var rooms:[Model] = []
    
    var body: some View {
        NavigationView {
            List(rooms) { room in
                Image(room.thumbImage)
                    .padding(.bottom)
                    .blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                VStack(alignment: .leading) {
                    Text(room.name)
                        .font(.title)
                        .fontWeight(.thin)
                    Text(room.desc)
                        .multilineTextAlignment(.leading)
                }
                
                
            }.navigationBarTitle(Text("List Items"))
            
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(rooms: testData)
    }
}

#endif
