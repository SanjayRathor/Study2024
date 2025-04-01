//
//  ColorUISlider.swift
//  SwitUIApp
//
//  Created by Sanjay Singh Rathor on 01/11/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import SwiftUI

struct ColorUISlider : UIViewRepresentable {
    func updateUIView(_ view: UISlider, context: Context) {
        
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        return slider
    }
}

//ColorUISlider wraps a UIView, not a UIViewController, so it conforms to UIViewRepresentable, not UIViewControllerRepresentable.
//The biggest difference between State and Binding is ownership. Views with property's marked with State have ownership. The system created storage on that specific views behalf. With property's marked with Binding, the view has read and write access, but not ownership.


struct ColorUISlider_Previews: PreviewProvider {
    static var previews: some View {
        ColorUISlider()
    }
}
