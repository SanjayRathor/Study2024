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

import UIKit

@IBDesignable
public class VoteButton: UIButton {
  
  @IBInspectable var buttonEnabledColor: UIColor = .buttonEnabled
  
  public override func awakeFromNib() {
    setup()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public override func prepareForInterfaceBuilder() {
    setup()
  }
  
  private func setup() {
    layer.cornerRadius = 10.0
    layer.borderColor = UIColor.buttonBorder.CGColor
    layer.borderWidth = 1 / UIScreen.mainScreen().scale
    setTitleColor(.buttonEnabledText, forState: .Normal)
    setTitleColor(.buttonDisabledText, forState: .Disabled)
    
    backgroundColor = .buttonEnabled
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 10.0)
    layer.shadowRadius = 10.0
  }
  
}

extension VoteButton {
  public func down() {
    layer.removeAllAnimations()
    
    UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: [.AllowUserInteraction], animations: {
      
      self.transform = CGAffineTransformMakeScale(0.65, 0.65)
      
      }, completion: nil)
  }
  
  public func up() {
    layer.removeAllAnimations()
    
    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [.AllowUserInteraction], animations: {
      
      self.transform = CGAffineTransformIdentity
      
      }, completion: nil)
  }
}

extension VoteButton {
  override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    down()
  }
  
  override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    up()
  }
  
  override public func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    super.pressesBegan(presses, withEvent: event)
    down()
  }
  
  override public func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    super.pressesEnded(presses, withEvent: event)
    up()
  }
}
