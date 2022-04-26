//
//  articleModel.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 08.04.2022.
//

import Foundation

struct ArticleJSON: Decodable {
    let title: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case text = "text"
    }
    
    init( fromArticle article: Article) {
        self.title = article.title ?? ""
        self.text = article.text ?? ""
    }
}
