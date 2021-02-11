//
//  TableViewCell.swift
//  NewsApp
//
//  Created by Maximilian Boiko on 09.02.2021.
//

import UIKit
import Alamofire
import AlamofireImage

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        authorLabel.text = article.author
        sourceLabel.text = article.source.name
    }
}
