//
//  ArticleRepository.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 26/01/22.
//

import Foundation
typealias FetchArticlesResult = (_ result: Result<[ArticleEntity], Error>) -> Void

protocol ArticleRepository {
    func fetchArticles(result: @escaping FetchArticlesResult)
}
