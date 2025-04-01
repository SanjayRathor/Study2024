//
//  Movie.swift
//  LerningUncleBlob
//
//  Created by Sanjay Singh Rathor on 24/01/22.
//

import Foundation

struct ArticleEntity {
    let author: String
    let content: String
    let title: String
    let description: String
    let url: URL
    let imageUrl: URL
    let publishedAt: Date
}

extension ArticleEntity: Equatable {
    
}
