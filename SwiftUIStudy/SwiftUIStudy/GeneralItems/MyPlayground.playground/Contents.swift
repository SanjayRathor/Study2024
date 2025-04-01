import UIKit

struct ChatMessage: Decodable, Identifiable {
    let id: Int
    var from: String
    var message: String
}

final class User: Decodable, Identifiable, Sendable {
    let id: UUID
    let name: String
    let age: Int
    init(id: UUID, name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }
}


func loadData() async {
    async let (userData, _) = URLSession.shared.data(from:URL(string: "https://hws.dev/user-24601.json")!)
    async let (messageData,_) = URLSession.shared.data(from:
                                                        URL(string: "https://hws.dev/user-messages.json")!)
    do {
        let decoder = JSONDecoder()
        let user = try await decoder.decode(User.self, from:
                                                userData)
        let messages = try await decoder.decode([ChatMessage].self,
                                                from: messageData)
        print("User \(user.name) has \(messages.count) message(s).")
    } catch {
        print("Sorry, there was a network problem.")
    }
}


//Task {
//    await loadData()
//}

func fetchFavorites(for user:  User) async -> [Int] {
    print("Fetching favorites for \(user.name)…")
    do {
        async let (favorites, _) = URLSession.shared.data(from:
                                                            URL(string: "https://hws.dev/user-favorites.json")!)
        return try await JSONDecoder().decode([Int].self, from:
                                                favorites)
    } catch {
        return []
    }
}


//Task {
//    let user = User(id: UUID(), name: "Taylor Swift", age: 26)
//    async let favorites = fetchFavorites(for: user)
//    await print("Found \(favorites.count) favorites.")
//}
/*
 func fetchData() async -> Data? {
 // do work here
 nil
 }
 func process(_
 data: Data?) async -> Bool {
 true
 }
 let download = await fetchData()
 let result = await process(download)
 
 func getAppData() async -> ([String], [String], Bool) {
 async let news = getNews()
 async let weather = getWeather()
 async let hasUpdate = getUpdateAvailable()
 return await (news, weather, hasUpdate)
 }
 */

//func fetchUsers() async throws {
//    let url = URL(string: "https://www.hackingwithswift.com/samples/news-1.json")!
//    for try await line in url.lines {
//        print("Received user: \(line)")
//    }
//}
//
//Task {
//    try? await fetchUsers()
//}

//func printUsers() async throws {
//    let url = URL(string: "https://hws.dev/users.csv")!
//    var iterator = url.lines.makeAsyncIterator()
//    if let line = try await iterator.next() {
//        print("The first user is \(line)")
//    }
//    for i in 2...5 {
//        if let line = try await iterator.next() {
//            print("User #\(i): \(line)")
//        }
//    }
//    var remainingResults = [String]()
//    while let result = try await iterator.next() {
//        remainingResults.append(result)
//    }
//    print("There were \(remainingResults.count) other users.")
//}
//try? await printUsers()
//func shoutQuotes() async throws {
//    let url = URL(string: "https://www.hackingwithswift.com/samples/news-1.json")!
//    let uppercaseLines = url.lines.map(\.localizedUppercase)
//
//    for try await line in uppercaseLines {
//        print(line)
//    }
//}
//try? await shoutQuotes()
//
//struct Quote {
//    let text: String
//}
//func printQuotes() async throws {
//    let url = URL(string: "https://hws.dev/quotes.txt")!
//    let quotes = url.lines.map(Quote.init)
//    for try await quote in quotes {
//        print(quote.text)
//    }
//}
//try? await printQuotes()
//
//func printAnonymousQuotes() async throws {
//    let url = URL(string: "https://hws.dev/quotes.txt")!
//    let anonymousQuotes = url.lines.filter
//    { $0.contains("Anonymous") }
//    for try await line in anonymousQuotes {
//        print(line)
//    }
//}
//


//for await item in stream {
//    print(item)
//}
//
//func printHighestNumber() async throws {
//    let url = URL(string: "https://hws.dev/random-numbers.txt")!
//    if let highest = try await
//        url.lines.compactMap(Int.init).max() {
//        print("Highest number: \(highest)")
//    } else {
//        print("No number was the highest.")
//    }
//}
//
//func printAnonymousQuotes() async throws {
//    let url = URL(string: "https://hws.dev/quotes.txt")!
//    let uppercaseLines = try await url.lines.compactMap(\.localizedUppercase)
//
//    for try await line in uppercaseLines {
//        print(line)
//    }
//}

//let stream = AsyncStream { continuation in
//    for i in 1...9 {
//        continuation.yield(i)
//    }
//    continuation.finish()
//}

//for await item in stream.prefix(3) {
//    print(item)
//}
//for await item in stream.prefix(1) {
//    print(item)
//}

//Task {
//    for await item in stream {
//        print("1. \(item)")
//    }
//}
//Task {
//    for await item in stream {
//        print("2. \(item)")
//    }
//}
//Task {
//    for await item in stream {
//        print("3. \(item)")
//    }
//}
//try? await Task.sleep(for: .seconds(1))

/*
 let stream = AsyncStream(bufferingPolicy: .bufferingNewest(5))
 { continuation in
 for i in 1...9 {
 continuation.yield(i)
 }
 continuation.finish()
 }
 for await item in stream {
 print(item)
 }
 It's worth spending a moment to really think what's happening there:
 • Swift adds 1, 2, 3, 4, and 5 to the stream as normal
 • When 6 comes in the buffer is full. So, it discards 1 (the oldest value) to make room,
 and adds 6 at the end.
 • This then happens again for 7, this time discarding the next oldest value, which is 2.
 • 8 then comes in, so 3 is discarded.
 • Finally, 9 is added to the stream, so 4 is discarded.
 • All this happens before our for await loop runs, which means by the time it does run
 the stream contains 5, 6, 7, 8, 9, which gets printed.
 
 
 let stream = AsyncStream(bufferingPolicy: .bufferingNewest(1) )
 { continuation in
 for i in 1...9 {
 continuation.yield(i)
 }
 continuation.finish()
 }
 for await item in stream {
 print(item)
 }
 
 for await item in stream {
 print(item)
 }
 
 
 let stream = AsyncStream(bufferingPolicy: .bufferingOldest(0))
 { continuation in
 continuation.yield("Hello, AsyncStream!")
 continuation.finish()
 }
 for await item in stream {
 print(item)
 }
 
 
 
 enum MultipleError: Error {
 case no3
 }
 let stream = AsyncThrowingStream { continuation in
 for i in 1...40 {
 continuation.yield(i)
 if i.isMultiple(of: 3) {
 continuation.finish(throwing: MultipleError.no3)
 }
 }
 continuation.finish()
 }
 
 do {
 for try await values in stream {
 print(values)
 }
 } catch {
 print("Error received: \(error)")
 }
 
 
 
 actor MyUser {
 
 func authenticate(user: String, password: String) -> Bool {
 return true
 }
 
 
 func login() async {
 Task.detached {
 if await self.authenticate(user: "taytay89", password: "n3wy0rk") {
 print("Successfully logged in.")
 } else {
 print("Sorry, something went wrong.")
 }
 }
 }
 }
 let user = MyUser()
 await user.login()
 try? await Task.sleep(for: .seconds(0.5))
 
 func factors(for number: Int) async -> [Int] {
 var result = [Int]()
 for check in 1...number {
 if number.isMultiple(of: check) {
 result.append(check)
 print("skldjfklajsdklfj \(check)")
 await Task.yield()
 }
 }
 return result
 }
 
 
 let results = await factors(for: 120)
 print("Found \(results.count) factors for 120.")
 
 
 func printMessage() async {
 let string = await withTaskGroup(of: Int.self) { group in
 group.addTask { 1 }
 group.addTask { 2 }
 group.addTask { 3 }
 group.addTask { 4 }
 group.addTask { 5 }
 var collected = [String]()
 for await value in group {
 collected.append(value)
 }
 return collected.joined(separator: " ")
 }
 print(string)
 }
 await printMessage()
 
 func printMessage() async {
 let result = await withThrowingTaskGroup(of: String.self)
 { group in
 group.addTask { try Task.checkCancellation()
 return "Testing" }
 group.addTask {
 
 return "Group"
 }
 group.addTask { "Cancellation" }
 
 group.cancelAll()
 var collected = [String]()
 do {
 for try await value in group {
 collected.append(value)
 }
 } catch {
 print(error.localizedDescription)
 }
 return collected.joined(separator: " ")
 }
 print(result)
 }
 await printMessage()
 
 
 struct RandomGenerator: AsyncSequence, AsyncIteratorProtocol {
 mutating func next() async -> Int? {
 try? await Task.sleep(for: .seconds(0.001))
 return Int.random(in: 1...Int.max)
 }
 func makeAsyncIterator() -> Self {
 self
 }
 }
 
 func doSomething () async {
 let generator = RandomGenerator()
 await withDiscardingTaskGroup { group in
 for await newNumber in generator {
 group.addTask {
 print(newNumber)
 }
 }
 }
 }
 await doSomething()
 */

enum Usere {
    @TaskLocal static var id = "Anonymous"
}

struct App {
    static func main() async throws {
        let first = Task {
            try await Usere.$id.withValue("Piper") {
                print("Start of task: \(Usere.id)")
                try await Task.sleep(for: .seconds(1))
                print("End of task: \(Usere.id)")
            }
        }
        let second = Task {
            try await Usere.$id.withValue("Alex") {
                print("Start of task: \(Usere.id)")
                try await Task.sleep(for: .seconds(1))
                print("End of task: \(Usere.id)")
            }
        }
        print("Outside of tasks: \(Usere.id)")
        try await first.value
        try await second.value
    }
}

