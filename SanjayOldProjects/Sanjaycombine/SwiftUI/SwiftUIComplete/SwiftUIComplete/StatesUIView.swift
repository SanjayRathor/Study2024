//
//  StatesUIView.swift
//  SwiftUIComplete
//
//  Created by Sanjay Singh Rathor on 26/11/20.
//

import SwiftUI

struct StatesUIView: View {
    
  @Binding var myStates:String
    
    init(myname: Binding<String>) {
        _myStates = myname
    }
    
    var body: some View {
        Text(myStates)
    }
}

struct StatesUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
           // StatesUIView(myname:("qda"))
            StatesUIView(myname: .constant("qda"))
        }
    }
}
