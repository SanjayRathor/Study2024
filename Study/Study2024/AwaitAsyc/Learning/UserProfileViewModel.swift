//
//  UserProfileViewModel.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/18/22.
//

import Foundation
import LocalAuthentication

class UserProfileViewModel: ObservableObject {
    @Published private(set) var userInfo: UserInfo?
    @Published private(set) var followingFollowersInfo: FollowerFollowingInfo?

    func fetchUserInfo() async throws -> UserInfo {
        
        return try await  UserAPI().fechUserInfo()
        
        
        let url = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/user_profile.json")!
        let (userInfoData, response) = try await URLSession.shared.data(from: url)
        let userInfo = try JSONDecoder().decode(UserInfo.self, from: userInfoData)
        return userInfo
    }
}
