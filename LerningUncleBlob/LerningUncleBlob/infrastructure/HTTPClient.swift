//
//  HTTPClient.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 27/01/22.
//

import Foundation

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(data:Data, response:HTTPURLResponse), Error>
    
    @discardableResult
    func dispatch(_ request:URLRequest, completion: @escaping (Result)->Void) -> HTTPClientTask
}
