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
    
    static func updateBanners( banners: [BannerJSON]? ) {
        guard let _ = banners else { return }
        
        let moc = AppDelegate.viewContext

        let request = Banner.fetchRequest()
        // remove all records
//        if let selection = try? moc.fetch(request) {
//            for item in selection {
//                moc.delete(item)
//            }
//        }
        
        // append new records
        for bannerDescription in banners! {
            let predicate = NSPredicate(format: "%K = %@", argumentArray: ["name", bannerDescription.name])
            request.predicate = predicate
            if let records = try? moc.fetch(request), records.count > 0 {
                // such record exist
            } else {
                updateBanner(banner: nil, withJSON: bannerDescription)
            }
        }
        
        saveContext()
    }
    
    static func updateBanner( banner: Banner?, withJSON bannerDescription: BannerJSON ){
        let moc = AppDelegate.viewContext

        var dbObject = banner
        if banner == nil {
            dbObject = Banner.init(context: moc)
        }
        dbObject?.name = bannerDescription.name
        dbObject?.color = bannerDescription.color
        dbObject?.active = bannerDescription.active

        saveContext()
    }

    static func updateArticles( articles: [ArticleJSON]? ) {
        guard let _ = articles else { return }
        
        let moc = AppDelegate.viewContext

        let request = Article.fetchRequest()
        // remove all records
//        if let selection = try? moc.fetch(request) {
//            for item in selection {
//                moc.delete(item)
//            }
//        }
        
        // append new records
        for itemDescription in articles! {
            let predicate = NSPredicate(format: "%K = %@", argumentArray: ["title", itemDescription.title])
            request.predicate = predicate
            if let records = try? moc.fetch(request), records.count > 0 {
                // such record exist
            } else {
                updateArticle(article: nil, withJSON: itemDescription)
            }
        }
        
        saveContext()
    }
    
    static func updateArticle( article: Article?, withJSON articleDescription: ArticleJSON ){
        let moc = AppDelegate.viewContext

        var dbObject = article
        if article == nil {
            dbObject = Article.init(context: moc)
        }
        dbObject?.title = articleDescription.title
        dbObject?.text = articleDescription.text

        saveContext()
    }

    // Entity for Name
    func entityForName(entityName: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: AppDelegate.viewContext)
    }

    // Fetched Results Controller for Entity Name
    func fetchedResultsController(entityName: String, keyForSort: String, predicate: NSPredicate?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    static func saveContext () {
        let context = AppDelegate.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
