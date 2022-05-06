//
//  ArticleViewCell.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 01.05.2022.
//

import UIKit

class ArticleViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWith(article: Article){
        var content = self.defaultContentConfiguration()

        // Configure content.
        //content.image = UIImage(systemName: "star")
        content.text = article.title
        content.secondaryText = article.text
        content.secondaryTextProperties.alignment = .justified

        self.contentConfiguration = content

    }

}
