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

enum RequestError: Error {
    case sessionError(error: Error)
}
struct WebSiteData: Codable {
    var rawHTML: String
}

let imageURLPublisher = PassthroughSubject<URL, RequestError>()


class CombileViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    var cancellables = Set<AnyCancellable>()
    var ajdh:Any? = nil
    
    @Published var sliderValue: Float = 0.1
    @Published var searchValue: String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    var model = MovieViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        showImage()
        /// model.crash()
        
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


/*
 // Generalized Publisher for Adaptive URL Loading
 func adaptiveLoader(regularURL: URL, lowDataURL: URL) -> AnyPublisher<Data, Error> { var request = URLRequest(url: regularURL) 1 request.allowsConstrainedNetworkAccess = false 2
 return URLSession.shared.dataTaskPublisher(for: request) 3
 .tryCatch { error -> URLSession.DataTaskPublisher in 4
 guard error.networkUnavailableReason == .constrained else {
 throw error }
 return URLSession.shared.dataTaskPublisher(for: lowDataURL) 5 .tryMap { data, response -> Data in
 guard let httpResponse = response as? HTTPUrlResponse, 6 httpResponse.status_code == 200 else {
 throw MyNetworkingError.invalidServerResponse return data
 .eraseToAnyPublisher() 7
 
 */

extension CombileViewController {
    
    func showImage() {
        /*
        let notFoundImage: UIImage? = UIImage.init(named: "wait")
        let cancellable = imageURLPublisher.flatMap { requestURL in
            return URLSession.shared.dataTaskPublisher(for: requestURL)
                .mapError { error -> RequestError in
                    return RequestError.sessionError(error: error)
                }
        }
            .retry(2)
            .map({ (result) -> UIImage? in
            return UIImage(data: result.data)
        })
          .catch({ (error) -> Just<UIImage?> in
            return Just(notFoundImage)
        }).receive(on: DispatchQueue.main, options: nil)
            .sink(receiveValue: { (image) in
                self.imageView.image = image
            }).store(in: &cancellables)
                
        imageURLPublisher.send(URL(string: "https://httpbin.org/image/jpege")!)
        */
        
        let myURL = URL(string: "https://www.example.com")

        ajdh = URLSession.shared.dataTaskPublisher(for: myURL!)
            .retry(3)
            .map({ (page) -> WebSiteData in
                return WebSiteData(rawHTML: String(decoding: page.data, as: UTF8.self))
            })
            .catch { error in
                return Just(WebSiteData(rawHTML: "<HTML>Unable to load page - timed out.</HTML>"))
        }
        .sink(receiveCompletion: { print ("completion: \($0)") },
              receiveValue: { print ("value: \($0)") }
         ).store(in: &cancellables)
    }
}
