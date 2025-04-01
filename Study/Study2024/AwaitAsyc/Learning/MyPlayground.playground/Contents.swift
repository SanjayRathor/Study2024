import UIKit


// Write a prograam that reads the contents of a URL and prints them to the console.
// The URL is: https://hws.dev/quotes.txt

//func loadQuotes() async {



//    let url = URL(string: "https://hws.dev/quotes.txt")!













//struct Videogame {
//        let title: String
//        let year: Int?
//        let score: Int?
//        init(rawLine: String) {
//                let splat = rawLine.split(separator: "|")
//                self.title = String(splat[0])
//                self.year = Int(splat[1])
//                self.score = Int(splat[2])
//            }
//}
//
//func loadVideogames() async {
//   let url = URL(string: "https://hws.dev/quotes.txt")!
//    for try await quote in url.lines {
//        print(\(quote))
//    }
//}
//
//Task {
//    loadVideogames()
//}
////Let videogames =
////    url
////    .lines
////    .filter { $0.contains("|") }
////    .map { Videogame(rawLine: $0) }
////    .filter { $0.score != 10 } // Apply the filter here
////do {
////    for try await videogame in videogames {
////        print("\(videogame.title) (\(videogame.year ?? 0))")
////    }
////} catch {
////}
