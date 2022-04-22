//
//  ViewController.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 08.04.2022.
//

import UIKit

class TestViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        objectsTableView.dataSource = self
        bannersCollectionView.dataSource = self
        bannersCollectionView.delegate = self
        
        // TODO: перемотка к нужной ячейке
        //bannersCollectionView.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: <#T##Bool#>)
        
        
        WebAPI.shared.getSiteData { responseData, error in
            DispatchQueue.main.async {
                self.banners?.removeAll()
                self.articles?.removeAll()
                if let _ = responseData, error == nil {
                    if let data = responseData {
                        self.banners = data.response.banners
                        self.articles = data.response.articles
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


    // MARK: - DataSource
    var banners: [BannerModel]?
    var articles: [ArticleModel]?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "banners"
        case 1:
            return "articles"
        default:
            return "section \(section)"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return banners?.count ?? 0
        case 1:
            return articles?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let object = banners?[ indexPath.row ] {
                var content = cell.defaultContentConfiguration()

                // Configure content.
                //content.image = UIImage(systemName: "star")
                content.text = object.name

                cell.contentConfiguration = content
            }
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
        }
        
        return cell
    }
    // MARK: - CollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerViewCell
        
        if let item = banners?[ indexPath.row ] {
            cell?.configWith(banner: item)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bannersCollectionView.visibleSize
    }
    

}

