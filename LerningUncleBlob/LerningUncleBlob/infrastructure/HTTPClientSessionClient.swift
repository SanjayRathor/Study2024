//
//  HTTPClientSessionClient.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 28/01/22.
//

import Foundation

final class HTTPClientSessionClient: HTTPClient {
    let session:URLSession
    init(session:URLSession){
        self.session = session
    }
    
    
    func dispatch(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return HTTPClientTaskWrapper(sessionTask: task)
    }
}

extension HTTPClientSessionClient {
    struct HTTPClientTaskWrapper: HTTPClientTask  {
        let sessionTask:URLSessionDataTask
        func cancel() {
            sessionTask.cancel()
        }
    }
    struct UnexpectedValuesRepresentation: Error {}
}



