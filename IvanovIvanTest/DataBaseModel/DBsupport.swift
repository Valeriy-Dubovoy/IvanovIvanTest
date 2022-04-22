//
//  DBsupport.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 18.04.2022.
//

import Foundation
import CoreData


class DBSupport {
    static let shared = DBSupport()
    
    static func updateBanners( banners: [BannerModel]? ) {
        guard let _ = banners else { return }
        
        let moc = AppDelegate.viewContext

        // remove all records
        let request = Banner.fetchRequest()
        if let selection = try? request.execute() {
            for item in selection {
                moc.delete(item)
            }
        }
        
        // append new records
        for bannerDescription in banners! {
            let newRecord = Banner(entity: request.entity!, insertInto: moc)
            newRecord.name = bannerDescription.name
            newRecord.color = bannerDescription.color
            newRecord.active = bannerDescription.active
        }
    }

    static func updateArticles( articles: [ArticleModel]? ) {
        guard let _ = articles else { return }
        
        let moc = AppDelegate.viewContext

        // remove all records
        let request = Article.fetchRequest()
        if let selection = try? request.execute() {
            for item in selection {
                moc.delete(item)
            }
        }
        
        // append new records
        for itemDescription in articles! {
            let newRecord = Article(entity: request.entity!, insertInto: moc)
            newRecord.text = itemDescription.text
            newRecord.title = itemDescription.title
        }
    }
}
