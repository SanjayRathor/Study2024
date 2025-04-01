//: Playground - noun: a place where people can play

import UIKit
import RVoteKit
import XCPlayground

let button = NSBundle(forClass: VoteButton.self).loadNibNamed("VoteButton", owner: nil, options: nil).first as! VoteButton

button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
view.backgroundColor = UIColor.whiteColor()

view.addSubview(button)

XCPlaygroundPage.currentPage.liveView = view


