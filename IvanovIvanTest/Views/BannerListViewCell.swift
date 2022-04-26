//
//  BannerListViewCell.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 26.04.2022.
//

import UIKit

class BannerListViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var banner: Banner?
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var actviveSwith: UISwitch!
    @IBAction func activeSwitchDidChanged(_ sender: UISwitch) {
        if self.banner != nil {
            self.banner?.active = sender.isOn //!banner!.active
            DBSupport.saveContext()
        }
        
    }
    
    func configWith( banner: Banner ) {
        titleLabel.text = banner.name
        actviveSwith.isOn = banner.active
        self.banner = banner
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
