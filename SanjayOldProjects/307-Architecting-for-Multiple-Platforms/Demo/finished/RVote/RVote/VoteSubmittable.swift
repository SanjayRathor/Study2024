//
//  VoteSubmittable.swift
//  RVote
//
//  Created by Erik Kerber on 2/10/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation

protocol VoteSubmittable {
  func submitVote(pollNumber: Int, answer: Int, completion: () -> Void)
  func getPoll(pollNumber: Int, completion: (Poll?) -> Void)
}
