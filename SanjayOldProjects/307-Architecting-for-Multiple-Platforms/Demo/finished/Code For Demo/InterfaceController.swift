/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import WatchKit
import Foundation
import RVoteKitWatch

protocol VoteAnswerDelegate: class {
  func pollSubmitted(answer: Int)
}

class VoteAnswerTableRowController: NSObject {

  weak var delegate: VoteAnswerDelegate?

  @IBOutlet var button: WKInterfaceButton!
  var voteAnswer: Int = 0

  @IBAction func butonPressed() {
    delegate?.pollSubmitted(voteAnswer)
  }
}

class InterfaceController: WKInterfaceController {

  @IBOutlet var pollTextGroup: WKInterfaceGroup!

  @IBOutlet var answerTable: WKInterfaceTable!

  @IBOutlet var pollLabel: WKInterfaceLabel!

  @IBOutlet var pollImage: WKInterfaceImage!

  var poll: Poll? = testPoll {
    didSet {

      guard let poll = poll else {
        answerTable.setNumberOfRows(0, withRowType: "VoteAnswerTableRowController")
        return
      }

      pollLabel.setText( poll.question )
      pollImage.setImage( poll.image )

      answerTable.setNumberOfRows(poll.answers.count, withRowType: "VoteAnswerTableRowController")

      for (i, answer) in poll.answers.enumerate() {
        let row = answerTable.rowControllerAtIndex(i) as! VoteAnswerTableRowController
        row.voteAnswer = answer.answerId
        row.button.setTitle(answer.answer)
        row.button.setBackgroundColor(.buttonEnabled)
        row.delegate = self
      }
    }
  }

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)

    poll = testPoll

    pollTextGroup.setBackgroundColor(.questionBackground)
    pollLabel.setTextColor(.questionText)
    // Configure interface objects here.

  }

  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
}

extension InterfaceController: VoteAnswerDelegate {
  func pollSubmitted(answer: Int) {

  }
}
