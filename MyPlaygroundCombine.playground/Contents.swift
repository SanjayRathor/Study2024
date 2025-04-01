
import Foundation
import Combine
/*
private var cancellable = Set<AnyCancellable>()
func getPostData()-> AnyPublisher<Data, Error> {
    let urls = [
        URL(string: "https://jsonplaceholder.typicode.com/posts/1")!,
        URL(string: "https://jsonplaceholder.typicode.com/posts/2")!,
        URL(string: "https://jsonplaceholder.typicode.com/posts/3")!
    ]

    // Create a publisher for each URL
    let publishers = urls.map { url in
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            //.catch { _ in Just(Data()) }
    }
    // Merge all publishers into a single stream
    let mergedPublisher = Publishers.MergeMany(publishers)
    return AnyPublisher(mergedPublisher)
}
func getFlatPostData()-> AnyPublisher<Data, Error> {
    let urlsPublisher = [
        URL(string: "https://jsonplaceholder.typicode.com/posts/1")!,
        URL(string: "https://jsonplaceholder.typicode.com/posts/2")!,
        URL(string: "https://jsonplaceholder.typicode.com/posts/3")!
    ].publisher

    // Create a publisher for each URL
    let publishers = urlsPublisher
        .flatMap { url in
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            //.catch { _ in Just(Data()) }
    }

    // Merge all publishers into a single stream
    ///let mergedPublisher = Publishers.MergeMany(publishers)
    return AnyPublisher(publishers).eraseToAnyPublisher()
}


@MainActor func perform() {
    // Subscribe to the merged publisher
    getFlatPostData()
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Finished receiving data.")
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }, receiveValue: { data in
            if let string = String(data: data, encoding: .utf8) {
                print("Converted string: \(string)")
            } else {
                print("Failed to convert data to string.")
            }
        })
        .store(in: &cancellable)
}

perform()
*/


protocol Vahicle {
    func drive()
}

struct ElectricVahicle: Vahicle {
    func drive() {
        print("Driving a Electric Vahicle")
    }
}

struct PetrolVahicle: Vahicle {
    func drive() {
        print("Driving a Petrol Vahicle")
    }
}

protocol Engine {
    func start()
}

struct PetrolEngine : Engine {
    func start() {
        print("start Petrol engine")
    }
}


struct ElectricEngine : Engine {
    func start() {
        print("start Electric engine")
    }
}

//Abstract Factory
protocol VahicleFactory {
    func createVahicle() -> Vahicle
    func createEngine() -> Engine
}


struct ElectricVahicleFactory:VahicleFactory {
    
    func createVahicle() -> Vahicle {
        return ElectricVahicle()
    }
    
    func createEngine() -> Engine
    {
        return ElectricEngine()
    }
}

struct PetrolVahicleFactory:VahicleFactory {
    
    func createVahicle() -> Vahicle {
        return PetrolVahicle()
    }
    
    func createEngine() -> Engine
    {
        return ElectricEngine()
    }
}



class Client {
    private let vehicle: Vahicle
    private let engine: Engine
    
    init(factory: VahicleFactory) {
        vehicle =  factory.createVahicle()
        engine = factory.createEngine()
    }
    
    func pefrom() {
        engine.start()
        self.vehicle.drive()
        
    }
    
}

Client(factory: ElectricVahicleFactory()).pefrom()


class Firease {
    func trackEvent(_ event: String) {
    print("FireaseAnalytics Tracking event: \(event)")
   }
}

protocol Analytics {
    func logEvent(_ event: String)
    
}

struct DefaultAnalytics: Analytics {
    func logEvent(_ event: String) {
        print("Logging event: \(event)")
    }
}

struct FireaseAdaptor: Analytics {
    
    let firebase = Firease()
    func logEvent(_ event: String) {
        firebase.trackEvent(event)
    }
}

struct Manager {
    let analytics:Analytics
    init(analytics:Analytics) {
        self.analytics = analytics
    }
    
    func log(_ event: String) {
        analytics.logEvent(event)
    }
}


Manager(analytics: FireaseAdaptor()).log("App Launch")


