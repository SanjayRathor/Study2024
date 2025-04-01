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


import RVoteKit

class VoteViewController: UIViewController {
  
  @IBOutlet weak var pollBox: PollBox!
  @IBOutlet weak var pollPic: UIImageView!
  @IBOutlet weak var buttonStackView: UIStackView!
  
  var poll: Poll? = testPoll {
    didSet {
      pollBox.pollText = poll?.question
      pollPic.image = poll?.image
      
      buttonStackView.arrangedSubviews.forEach {
        buttonStackView.removeArrangedSubview( $0 )
        $0.removeFromSuperview()
      }
      
      poll?.answers.map { answer in
        let button = VoteButton(frame: CGRectZero)
        button.setTitle(answer.answer, forState: .Normal)
        button.addTarget(self, action: #selector(VoteViewController.selectedAnswer(_:)), forControlEvents: .TouchUpInside)
        button.tag = answer.answerID
        return button
        }.forEach { button in
          buttonStackView.addArrangedSubview ( button )
      }
    }
  }
  
  func selectedAnswer(sender: VoteButton) {
    if sender.tag == 1 {
      pollBox.pollText = "Correct!"
    } else {
      pollBox.pollText = "WRONG!!!"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    poll = testPoll
    view.backgroundColor = .background
  }
}

