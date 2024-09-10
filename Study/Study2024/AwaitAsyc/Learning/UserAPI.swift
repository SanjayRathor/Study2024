//
//  UserAPI.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/12/22.
//

import Foundation

class UserAPI {
    func fetchUserInfo(
        completionHandler: @escaping (_ userInfo: UserInfo?, _ error: Error?) -> Void
    ) {
        let url = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/user_profile.json")!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                    completionHandler(userInfo, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchFollowingAndFollowers(
        completionHandler: @escaping (_ followingFollowers: FollowerFollowingInfo?, _ error: Error?) -> Void
    ) {
        let url = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/user_followers.json")!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    let followingFollowers = try JSONDecoder().decode(FollowerFollowingInfo.self, from: data)
                    completionHandler(followingFollowers, nil)
                } catch {
                    completionHandler(nil, error)
                }
            }
        }
        dataTask.resume()
    }
}

