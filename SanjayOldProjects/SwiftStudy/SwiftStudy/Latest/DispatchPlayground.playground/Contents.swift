import UIKit
//
//var workItem = DispatchWorkItem() {
//}
//
//func performWork() {
//    //let queue = DispatchQueue(label: "com.swiftpal.dispatch.qos", attributes: .concurrent)
////    DispatchQueue.main.async {
////        workItem.cancel()
////        workItem.perform()
////
////    }
//
//    // Class level variable
//    let queue = DispatchQueue(label: "com.raywenderlich.worker")
//    queue.sync {
//      print("Inner")
//    DispatchQueue.main.sync {
//        print("Inner-2")
//    }
//    }
//}
//
//let group = DispatchGroup()
//group.notify(queue: .main) {
//
//}
/*let group = DispatchGroup()
 let queue = DispatchQueue.global(qos: .userInitiated)
 queue.async(group: group) {
 print("Start job 1")
 Thread.sleep(until: Date().addingTimeInterval(10))
 print("End job 1")
 }
 queue.async(group: group) {
 print("Start job 2")
 Thread.sleep(until: Date().addingTimeInterval(2))
 print("End job 2")
 }
 
 if group.wait(timeout: .now() + 5) == .timedOut {
 print("I got tired of waiting")
 } else {
 print("All the jobs have completed")
 }
 */

//let group = DispatchGroup()
//let queue = DispatchQueue(label: "com.raywenderlich.worker")
//queue.dispatch(group: group) {
//// count is 1
//group.enter()
//// count is 2
// someAsyncMethod {
// defer { group.leave() }
//    // Perform your work here,
//    // count goes back to 1 once complete
//    }
//}
//
//func myAsyncAdd(
//    lhs: Int,
//    rhs: Int,
//    completion: @escaping (Int) -> Void) {
//    // Lots of cool code here completion(lhs + rhs)
//}
//func myAsyncAddForGroups(
//    group: DispatchGroup,
//    lhs: Int,
//    rhs: Int,
//    completion: @escaping (Int) -> Void) { group.enter()
//    myAsyncAdd(first: first, second: second) {
//        result in defer { group.leave() }
//        completion(result)
//    }
//}
//


func startTask(queue: DispatchQueue, group: DispatchGroup) {
    queue.async(group: group) {
       // group.enter()
        for _ in 0..<10 {
            print("aaaaaa")
        }
        print("bbbb")
        //group.leave()
        
    }
    
}

let dispatchQueue = DispatchQueue(label: "com.alfianlosari.test", qos: .userInitiated, attributes: .concurrent)
let dispatchGroup = DispatchGroup()

startTask(queue: dispatchQueue, group: dispatchGroup)


struct najskd {
    subscript(index) {
        
    }
}
