//
//  ArticleImageTableViewCell.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 02.05.2022.
//

import UIKit

class ArticleImageTableViewCell: UITableViewCell {
    
    var articleJSON: ArticleJSON? {
        didSet {
            headerLabel.text = articleJSON?.title
            articleTextField.text = articleJSON?.text
            // image not changed
        }
    }
    var tableWidth: CGFloat = 0.0
    
    lazy var stackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [imageArticleView, headerLabel, articleTextField])
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 8
        vStack.contentMode = .scaleAspectFit
        
        return vStack
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.text = articleJSON?.title
        
        //label.backgroundColor = .brown
        return label
    }()
    
    private lazy var imageArticleView: UIImageView = {
        let view = UIImageView(image: articleImage)
        view.contentMode = .scaleAspectFit

        return view
    }()
    
    lazy private var articleImage: UIImage? = {
        if let image = UIImage(named: "bannerImage") {
            return image
        }
        return UIImage(systemName: "questionmark.app")
    }()
    
    private lazy var articleTextField: UILabel = {
        let textField = UILabel()
        textField.font = UIFont.preferredFont(forTextStyle: .footnote)
        textField.numberOfLines = 0
        textField.textAlignment = .justified
        textField.text = articleJSON?.text
        
        return textField
    }()
    
    // space between margins
    private var usefullWidth: CGFloat {
        self.bounds.width - self.layoutMargins.left - self.layoutMargins.right
    }
    
    func heightOfCell() -> CGFloat {
        return -1
    }
    
    func config() {
        let ratio = ( articleImage?.size.width ?? 0 ) / ( articleImage?.size.height ?? 1 )
        
        self.contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        // autolayout rules
        constraints.append( NSLayoutConstraint(item: imageArticleView,
                                               attribute: .height,
                                               relatedBy: .equal,
                                               toItem: imageArticleView,
                                               attribute: .width,
                                               multiplier: ratio,
                                               constant: 0) )

        
         
        let views: [String: Any] = ["stackView" : stackView]
        var formatString = "|-[stackView]-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: formatString, options: [], metrics: nil, views: views)

        formatString = "V:|-[stackView]-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: formatString, options: [.alignAllCenterX], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
/*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
}
