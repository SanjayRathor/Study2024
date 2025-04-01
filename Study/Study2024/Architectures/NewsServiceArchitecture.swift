//
//  NewsServiceArchitecture.swift
//  Study2024
//
//  Created by Sanjay Rathor on 03/04/24.
//

import Foundation
/*
    DOMAIN LAYER DESCRIPTIONS
 */

struct UserStory { }
struct UserStoryDetails { }
struct FetchUserStoriesError:Error { }
struct ViewUserStoriesError:Error { }
struct SyncUserStoriesError:Error { }
struct StoriesRepositoryError:Error { }

protocol FetchUserStoriesUsecase {
    func fetchStories(userId: String,
                    pageInfo: Int) async -> Result<[UserStory], FetchUserStoriesError>
}

protocol ViewUserStoriesUsecase {
    func fetchFullStoryDetails(userId: String,
                               storyId: String) async -> Result<UserStoryDetails, ViewUserStoriesError>
}

protocol SyncUserStoriesUsecase {
    func syncUserStories(userStories: Data) async -> Result<Bool, SyncUserStoriesError>
}


///domain layer would be interacting with, the data later interfaces/protocols, which is basically the Repositories.
protocol StoriesRepository {
    func fetchStories(userId: String,
                    pageInfo: Int) async -> Result<[UserStory], StoriesRepositoryError>
    func fetchFullStoryDetails(userId: String,
                     storyId: String) async -> Result<UserStoryDetails, StoriesRepositoryError>
    func markViewed(storyId: String) async -> Result<Bool, StoriesRepositoryError>
}



struct LocalStoryRepository : StoriesRepository {
   
    func fetchStories(userId: String, pageInfo: Int) async -> Result<[UserStory], StoriesRepositoryError> {        
        .success([])
    }
    
    func fetchFullStoryDetails(userId: String, storyId: String) async -> Result<UserStoryDetails, StoriesRepositoryError> {
        .success(UserStoryDetails())
    }
    
    func markViewed(storyId: String) async -> Result<Bool, StoriesRepositoryError> {
        .success(true)
    }
}

struct WebStoryRepository : StoriesRepository {
    func fetchStories(userId: String, pageInfo: Int) async -> Result<[UserStory], StoriesRepositoryError> {
        
        .success([])
    }
    
    func fetchFullStoryDetails(userId: String, storyId: String) async -> Result<UserStoryDetails, StoriesRepositoryError> {
        .success(UserStoryDetails())
    }
    
    func markViewed(storyId: String) async -> Result<Bool, StoriesRepositoryError> {
        .success(true)
    }
}
