//
//  SearchMoviesUseCase.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 25/01/22.
//

import Foundation

typealias FetchArticlesUseCaseCompletionHandler = (_ articles: [ArticleEntity]) -> Void

protocol FetchArticlesUseCase {
    func execute(_ completionHandler: @escaping FetchArticlesUseCaseCompletionHandler)
}
