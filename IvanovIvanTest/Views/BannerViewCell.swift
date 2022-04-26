//
//  BannerViewCell.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 20.04.2022.
//

import UIKit

class BannerViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerTitleLabel: UILabel!
    
    func configWith(banner: Banner) {
        self.bannerTitleLabel.text = banner.name
       // self.contentView.backgroundColor = UIColor(named: banner?.color )
    }
}
