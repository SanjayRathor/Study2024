//
//  CombileViewController.swift
//  Study2024
//
//  Created by Sanjay Singh Rathor on 15/10/23.
//

import UIKit
import Combine

public class DataClass: Codable {
    let original: String
    let md5: Int
}

class CombileViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    var cancellables = Set<AnyCancellable>()
    
    @Published var sliderValue: Float = 0.1
    @Published var searchValue: String = ""
    
    var model = MovieViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.refreshToken()
            .sink(receiveCompletion: { completion in
                print(completion)
                if case .failure(let err) = completion {
                    print("error \(err)")
                }
            }, receiveValue: { (model) in
                print(model)
            }).store(in: &cancellables)
        
        
        /*  guard let url = URL(string: "http://md5.jsontest.com/?text=example_text") else { return }
         let publisher: AnyPublisher<DataClass, Error> = model.fetchURL(url)
         publisher
         .sink(receiveCompletion: { completion in
         print(completion)
         if case .failure(let err) = completion {
         print("error \(err)")
         }
         }, receiveValue: { (model: DataClass) in
         print(model)
         }).store(in: &cancellables)
         */
        
        
        
        ///The subscriber will only receive values that were not followed up by a new value within 300 milliseconds.
        //        $sliderValue
        //        .debounce(for: 0.30, scheduler: DispatchQueue.main)
        //        .throttle(for: 0.30, scheduler: DispatchQueue.main, latest: true)
        //        .assign(to: \.value, on: slider)
        //        .store(in: &cancellables)
        
        
        $searchValue
        // .debounce(for: 0.30, scheduler: DispatchQueue.main)
            .throttle(for: 0.30, scheduler: DispatchQueue.main, latest: false)
            .sink(receiveValue: { value in
                print("\(value)")
            })
        
            .store(in: &cancellables)
        
        
        /*
         $searchQuery
         .debounce(for: 0.3, scheduler: DispatchQueue.main)
         .filter({ ($0 ?? "").count > 2 }) .removeDuplicates()
         .print()
         .assign(to: \.text, on: label)
         .store(in: &cancellables)
         */
        
        /*
         $firstName .combineLatest($lastName) .map({ combined in
         return "\(combined.0) \(combined.1)" })
         .assign(to: \.text, on: fullNameLabel) .store(in: &cancellables)
         }
         */
        
    }
    ///While debounce resets its cooldown period for every received value, the throttle operator will emit values at a given interval.
    @IBAction func pushDidClicked(_ sender: Any) {
        sliderValue += 0.1
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchValue  = searchText
        
    }
    /*
     func fetchURL<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
     URLSession.shared.dataTaskPublisher(for: url)
     .tryMap({ result in
     let decoder = JSONDecoder()
     return try decoder.decode(T.self, from: result.data)
     })
     .eraseToAnyPublisher()
     }
     
     
     var cancellables = Set<AnyCancellable>()
     let publisher: AnyPublisher<MyModel, Error> = fetchURL(myURL)
     publisher
     .sink(receiveCompletion: { completion in
     print(completion)
     }, receiveValue: { (model: MyModel) in
     print(model)
     }).store(in: &cancellables)
     
     
     
     let publisher: AnyPublisher<MyModel, Error> = fetchURL(myURL)
     .share()
     .eraseToAnyPublisher()
     */
    
    func fetchURL2<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .share()
            .eraseToAnyPublisher()
    }
}


