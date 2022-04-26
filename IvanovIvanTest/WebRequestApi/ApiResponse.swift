//
//  ApiResponse.swift
//  GoKaliningrad
//
//  Created by Admin on 20.08.2021.
//

import Foundation

struct commonResponse : Decodable {
    let banners:[ BannerJSON ]?
    let articles: [ ArticleJSON ]?
    
    enum CodingKeys: String, CodingKey {
        case banners = "banners"
        case articles = "articles"
    }
}

struct ResponseData {
    let response: commonResponse
    let jsonData: Data
}



