//
//  ArticleRepository.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 29/01/22.
//

import Foundation

struct ArticleRepositoryImpl: ArticleRepository {
    
    private let remoteDataSource: ArticleRepository
    private let localDataSource: ArticleRepository
    
    var isNetworkReachible = false
    public init(remoteDataSource: ArticleRepository, localDataSource: ArticleRepository) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    func fetchArticles(result: @escaping FetchArticlesResult) {
        if isNetworkReachible {
            remoteDataSource.fetchArticles { result2 in
                result(result2)
            }
        } else {
            localDataSource.fetchArticles { result2 in
                result(result2)
            }
        }
    }
}
// let dataStore = ArticleRepositoryImpl.init(remoteDataSource: RemoteDataSource(), localDataSource: LocalStorageDataSource())
