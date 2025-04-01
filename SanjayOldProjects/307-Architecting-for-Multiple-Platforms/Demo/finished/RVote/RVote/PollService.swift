//
//  PollService.swift
//  RVote
//
//  Created by Erik Kerber on 12/26/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

private var samplePolls: [PListPoll] = {
  let eve = PListPoll()
  eve.title = "Erik vs Eric"
  eve.pollID = "1"
  eve.image = "eve"
  eve.answers = ["1": PListPoll.PListAnswer(answerText: "Erik"), "2": PListPoll.PListAnswer(answerText: "Eric")]
  
  let emacsvim = PListPoll()
  emacsvim.title = "Emacs vs. Vim"
  emacsvim.pollID = "2"
  emacsvim.image = "emacsvim"
  emacsvim.answers = ["1": PListPoll.PListAnswer(answerText: "Emacs"), "2": PListPoll.PListAnswer(answerText: "Vim")]
  
  let dogs = PListPoll()
  dogs.title = "Favorite Dog?"
  dogs.pollID = "3"
  dogs.image = "dogs"
  dogs.answers = ["1": PListPoll.PListAnswer(answerText: "Labrador"), "2": PListPoll.PListAnswer(answerText: "Pug"), "3": PListPoll.PListAnswer(answerText: "Beagle"), "4": PListPoll.PListAnswer(answerText: "Pitbull")]
  
  return [eve, emacsvim, dogs]
}()

@objc
private class PListPoll: NSObject, NSCoding {
  
  var title: String = ""
  var pollID: String = ""
  var image: String = ""
  var answers: [String: PListAnswer] = [:]
  
  @objc func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(title, forKey: "title")
    aCoder.encodeObject(pollID, forKey: "pollID")
    aCoder.encodeObject(image, forKey: "image")
    aCoder.encodeObject(answers, forKey: "answers")
  }
  
  override init() {
    super.init()
  }
  
  @objc required init?(coder aDecoder: NSCoder) {
    self.title = aDecoder.decodeObjectForKey("title") as! String
    self.pollID = aDecoder.decodeObjectForKey("pollID") as! String
    self.image = aDecoder.decodeObjectForKey("image") as! String
    self.answers = aDecoder.decodeObjectForKey("answers") as! [String: PListAnswer]
    super.init()
  }
  
  private class PListAnswer: NSObject, NSCoding {
    
    let answerText: String
    var votes: Int = 0
    
    init(answerText: String) {
      self.answerText = answerText
      super.init()
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(answerText, forKey: "answerText")
      aCoder.encodeObject(votes, forKey: "votes")
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
      self.answerText = aDecoder.decodeObjectForKey("answerText") as! String
      self.votes = aDecoder.decodeObjectForKey("votes") as! Int
      super.init()
    }
  }
}

final class PollService: VoteSubmittable {
  
  private let path: String
  private var polls: [PListPoll]
  
  init() {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    self.path = documentsDirectory.stringByAppendingPathComponent("data.plist")
    
    if !NSFileManager.defaultManager().fileExistsAtPath(self.path) {
      self.polls = samplePolls
    } else {
      self.polls = NSKeyedUnarchiver.unarchiveObjectWithData(NSData(contentsOfFile: path)!) as! [PListPoll]
    }
  }
  
  func getPoll(pollNumber: Int, completion: (Poll?) -> Void) {
    
    if polls.count <= pollNumber {
      let emptyPoll = Poll(question: "No more polls!", image: nil, answers: [])
      completion(emptyPoll)
      return
    }
    
    let poll = Poll( question: polls[pollNumber].title,
      image: UIImage(named: polls[pollNumber].image),
      answers: polls[pollNumber].answers.map { id, answer in Answer(answer: answer.answerText, answerID: Int(id)!) })
    
    completion(poll)
  }
  
  func submitVote(pollNumber: Int, answer: Int, completion: () -> Void) {
    polls[pollNumber].answers["\(answer)"]?.votes += 1
    NSKeyedArchiver.archiveRootObject(polls, toFile: path)
    completion()
  }
}
