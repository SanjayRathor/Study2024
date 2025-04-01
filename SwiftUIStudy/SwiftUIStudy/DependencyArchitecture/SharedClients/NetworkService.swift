//
//  NetworkClient.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 30/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import Foundation
protocol NetworkService {
 func getData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
