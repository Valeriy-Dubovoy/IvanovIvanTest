//
//  ViewController.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 08.04.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        objectsTableView.dataSource = self
        objectsTableView.delegate = self
        bannersCollectionView.dataSource = self
        bannersCollectionView.delegate = self
        
        bannersFRC.delegate = self
        do {
             try bannersFRC.performFetch()
         } catch {
             print(error)
         }

        // TODO: перемотка к нужной ячейке
        //bannersCollectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
        
        
        WebAPI.shared.getSiteData { responseData, error in
            DispatchQueue.main.async {
                //self.banners.removeAll()
                self.articles?.removeAll()
                if let _ = responseData, error == nil {
                    if let data = responseData {
                        DBSupport.updateBanners(banners: data.response.banners)
                        //self.getBannersData()
                        self.articles = data.response.articles
                        DBSupport.updateArticles(articles: self.articles)
                    }
                }
                
                self.objectsTableView.reloadData()
                self.bannersCollectionView.reloadData()
            }

        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // установить новый размер ячейки
        bannersCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBOutlet weak var bannersCollectionView: UICollectionView!
    @IBOutlet weak var objectsTableView: UITableView!


    // MARK: - Banners DataSource
    
    lazy var bannersFRC: NSFetchedResultsController<NSFetchRequestResult> = {
        let predicate = NSPredicate(format: "%K == %@", argumentArray: ["active", true])
        
        return DBSupport.shared.fetchedResultsController(entityName: "Banner", keyForSort: "name", predicate: predicate)
    }()
    
    /*
    private func getBannersData() {
        let request = Banner.fetchRequest()
        
        do {
            banners = try AppDelegate.viewContext.fetch(request) //request.execute()
        } catch {
            print("banners did not read from database")
        }
    }
     */
    
    var banners: [Banner] = []
    
    // MARK: - Articles DataSource
   var articles: [ArticleJSON]?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "articles"
        /*switch section {
        case 0:
            return "banners"
        case 1:
            return "articles"
        default:
            return "section \(section)"
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
        /*switch section {
        case 0:
            return banners.count
        case 1:
            return articles?.count ?? 0
        default:
            return 0
        }*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let object = articles?[ indexPath.row ] {
            var content = cell.defaultContentConfiguration()

            // Configure content.
            //content.image = UIImage(systemName: "star")
            content.text = object.title
            content.secondaryText = object.text
            content.secondaryTextProperties.alignment = .justified

            cell.contentConfiguration = content
        }
        /*switch indexPath.section {
        case 0:
            let object = banners[ indexPath.row ]
            var content = cell.defaultContentConfiguration()

            // Configure content.
            //content.image = UIImage(systemName: "star")
            content.text = object.name
            content.secondaryText = object.active ? "On" : "Off"

            cell.contentConfiguration = content
        case 1:
            if let object = articles?[ indexPath.row ] {
                var content = cell.defaultContentConfiguration()

                // Configure content.
                //content.image = UIImage(systemName: "star")
                content.text = object.title
                content.secondaryText = object.text

                cell.contentConfiguration = content
            }
        default:
            break
        }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = articles?[ indexPath.row ] {
            performSegue(withIdentifier: "showArticle", sender: object)
        }
    }
    // MARK: - CollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = bannersFRC.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerViewCell

        let item = bannersFRC.object(at: indexPath) as! Banner
                
        cell?.configWith(banner: item)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bannersCollectionView.visibleSize
    }
    

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        bannersCollectionView.reloadData()
        
        
    }
    
    // MARK: - Fetched Results Controller Delegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //bannersCollectionView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            if let indexPath = newIndexPath {
//                objectsTableView.insertRows(at: [indexPath], with: .automatic)
//                //insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            }
//        case .update:
//            if let indexPath = indexPath {
//                let customer = fetchedResultsController.objectAtIndexPath(indexPath) as! Customer
//                let cell = tableView.cellForRowAtIndexPath(indexPath)
//                cell!.textLabel?.text = customer.name
//            }
//        case .move:
//            if let indexPath = indexPath {
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            }
//            if let newIndexPath = newIndexPath {
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
//            }
//        case .delete:
//            if let indexPath = indexPath {
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            }
//        @unknown default:
//            <#fatalError()#>
//        }
        //getBannersData()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.endUpdates()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArticle" {
            let item = sender as! ArticleJSON
            let nvc = segue.destination as! UINavigationController

            let vc = nvc.topViewController as! ArticleViewController
            vc.article = item
        }
    }
}

