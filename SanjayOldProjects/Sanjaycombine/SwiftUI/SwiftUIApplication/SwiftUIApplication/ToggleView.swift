//
//  ToggleView.swift
//  SwiftUIApplication
//
//  Created by Sanjay Singh Rathor on 10/11/20.
//

import SwiftUI

struct ToggleView: View {
    @Binding var isOnButtton:Bool
    var body: some View {
        Toggle(isOn: $isOnButtton, label: {
            Text("")
        }).fixedSize()
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView(isOnButtton: .constant(false))
    }
}
