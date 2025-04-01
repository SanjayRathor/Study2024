//
//  FetchArticlesUseCaseImpl.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 26/01/22.
//

import Foundation

class FetchArticlesUseCaseImpl: FetchArticlesUseCase {
    let articleRepository: ArticleRepository
    var lastFetchedAt: Date? = nil
    var lastFetchedArticles: [ArticleEntity]? = nil
    
    init(articleRepository: ArticleRepository) {
        self.articleRepository = articleRepository
    }
    
    func execute(_ completionHandler: @escaping FetchArticlesUseCaseCompletionHandler) {
        guard shouldUpdate() else {
            return
        }
        articleRepository.fetchArticles { [weak self] fetchArticlesResult in
            switch fetchArticlesResult {
            case .success(let articles):
                self?.lastFetchedAt = Date()
                self?.lastFetchedArticles = articles
                completionHandler(articles)
            case .failure:
                break
            }
        }
    }
    
    private func shouldUpdate() -> Bool {
        guard lastFetchedAt != nil else {
            return true
        }
        return true
    }
}
