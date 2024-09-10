import UIKit
import CoreLocation

func doSomeThing() async ->String {
    return "Sanjay"
}

Task {
 let files =  await doSomeThing()
  
}

//var myProperty: String {
//  get async {
//    }
//}
//print(await myProperty)
//class LocManager {
//    
//    func handleUpdates() async {
//        let location: CLLocation = try await
//            withCheckedThrowingContinuation { [weak self] continuation in
//             
//                
//        }
//    }
//}
//for await item in asyncSequence
//  .dropFirst(5)
//  .prefix(10)
//  .filter { $0 > 10 }
//  .map { "Item: \($0)" } {
//... }


//func taskGrpup() {
//    //1
//    let images = try await withThrowingTaskGroup( of: Data.self, returning: [UIImage].self ) 
//    {
//        group in
//        
//        for index in 0..<numberOfImages {
//            let url = baseURL.appendingPathComponent("image \(index).png")
//            group.addTask {
//                return try await URLSession.shared
//                    .data(from: url, delegate: nil)
//                    .0
//            }
//        }
//        return try await group.reduce(into: [UIImage]()) { result,
//            data in
//            if let image = UIImage(data: data) {
//                result.append(image)
//                
//            }
//        }
//    }
//}
