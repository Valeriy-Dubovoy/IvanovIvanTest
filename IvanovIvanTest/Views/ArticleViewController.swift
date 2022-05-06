//
//  ArticleViewController.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 01.05.2022.
//

import UIKit
import CoreData

class ArticleViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var article: ArticleJSON? {
        didSet {
            if articlesTableView != nil {
                initArticlesData()
                //articlesTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        
        initArticlesData()
        articlesFRC.delegate = self

    }
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Fetched Results Controller

    var articlesFRC: NSFetchedResultsController<NSFetchRequestResult>!
    
    func getArticlesFRC() -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K != %@", argumentArray: ["title", article?.title ?? ""])
        
        return DBSupport.shared.fetchedResultsController(entityName: "Article", keyForSort: "title", predicate: predicate)
    }
    
    func initArticlesData() {
        articlesFRC = getArticlesFRC()
        do {
             try articlesFRC.performFetch()
         } catch {
             print(error)
         }
        
        articlesTableView.reloadData()
        articlesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    // MARK: - Fetched Results Controller Delegate

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        articlesTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                articlesTableView.insertRows(at: [indexPath], with: .automatic)
                //insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let item = articlesFRC.object(at: indexPath) as! Article
                let cell = articlesTableView.cellForRow(at: indexPath) as! ArticleViewCell
                cell.configWith(article: item)
            }
        case .move:
            if let indexPath = indexPath {
                articlesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                articlesTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                articlesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            print("New operation in NSFetchedResultsChangeType")
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        articlesTableView.endUpdates()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 1 for image + header$
        // 2 for table
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //for image+header
            return 1
        }
        if let sections = articlesFRC.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "articleImageCell", for: indexPath) as! ArticleImageTableViewCell
            cell.articleJSON = article
            cell.config()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleViewCell

        let rightIndexPath = IndexPath(row: indexPath.row, section: 0)
        let item = articlesFRC.object(at: rightIndexPath) as! Article
                
        // Configure the cell...
        cell.configWith(article: item)

        return cell
    }
    
    // MARK: Table view Delegate
    
    func tableView(_ tableView: UITableView,
                        heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0, indexPath.row == 0 {
            if let cell = tableView.cellForRow(at: indexPath) {
                return cell.bounds.height
            }
            //let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
            //return cell?.bounds.height ?? 50
            // image cell
            let cell = ArticleImageTableViewCell()
            cell.articleJSON = article
            return cell.heightOfCell()
        }
        return -1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let correctIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
            let item = articlesFRC.object(at: correctIndexPath) as! Article
            article = ArticleJSON(fromArticle: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
