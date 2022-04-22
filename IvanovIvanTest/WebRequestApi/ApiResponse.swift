//
//  ApiResponse.swift
//  GoKaliningrad
//
//  Created by Admin on 20.08.2021.
//

import Foundation

struct commonResponse : Decodable {
    let banners:[ BannerModel ]?
    let articles: [ ArticleModel ]?
    
    enum CodingKeys: String, CodingKey {
        case banners = "banners"
        case articles = "articles"
    }
}

struct ResponseData {
    let response: commonResponse
    let jsonData: Data
}



