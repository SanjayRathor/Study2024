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

internal struct Clay {
  static let dark = UIColor(h: 221, s: 61, b: 13)
  static let cream = UIColor(h: 26, s: 13, b: 100)
  static let green = UIColor(h: 71, s: 50, b: 85)
  static let brown = UIColor(h: 7, s: 31, b: 53)
  static let teal = UIColor(h: 158, s: 22, b: 88)
}

internal struct RColors {
  private static let wendergreen = UIColor(r: 12, g: 87, b: 42)
  private static let wenderorange = UIColor(r: 233, g: 123, b: 31)
  private static let wendergray = UIColor(r: 30, g: 30, b: 30)
}

private extension UIColor {
  
  private convenience init(r: Float, g: Float, b: Float) {
    self.init(colorLiteralRed: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
  }
  
  private convenience init(h: CGFloat, s: CGFloat, b: CGFloat) {
    self.init(hue: h / 360.0, saturation: s / 100.0, brightness: b / 100.0, alpha: 1.0)
  }
}

public extension UIColor {
  
  public class var text: UIColor {
    return Clay.dark
  }
  
  public class var background: UIColor {
    return Clay.cream
  }
  
  public class var questionBackground: UIColor {
    return Clay.dark
  }
  
  public class var questionText: UIColor {
    return Clay.cream
  }
  
  public class var buttonEnabled: UIColor {
    return Clay.green
  }
  
  public class var buttonEnabledText: UIColor {
    return Clay.dark
  }
  
  public class var buttonDisabledText: UIColor {
    return Clay.cream
  }
  
  public class var buttonBorder: UIColor {
    return Clay.dark
  }
  
  public class var highlight: UIColor {
    return Clay.green
  }
}
