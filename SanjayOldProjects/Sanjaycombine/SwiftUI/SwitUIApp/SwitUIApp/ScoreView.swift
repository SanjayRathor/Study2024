//
//  StatePassing.swift
//  SwitUIApp
//
//  Created by Sanjay Singh Rathor on 04/11/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct ScoreView {
  @Binding private var answered: Int
  private let questions: Int
  init(answered: Binding<Int>, of questions: Int) {
    self._answered = answered
    self.questions = questions
  }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
