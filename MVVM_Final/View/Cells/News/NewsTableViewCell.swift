//
//  NewsTableViewCell.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 11.06.2021.
//

import UIKit
import Kingfisher

protocol NewsTableViewCellGetAllProtocol: NSObjectProtocol {
    func getAll()
}

class NewsTableViewCell: UITableViewCell {
    public static let identifier: String = "NewsTableViewCell"
    public static let nib = UINib(nibName: identifier, bundle: nil)
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    weak var delegate: NewsTableViewCellGetAllProtocol?
    
    public var news: NewsModel.News? {
        didSet {
            if let news = news {
                if let url = news.urlImage {
                    var urlImage: String!
                    if url.isEmpty == false {
                        urlImage = url
                    } else {
                        urlImage = "http://godsanswermodelcollege.com.ng/private/images/default_news.jpg"
                    }
                    let posterURL = URL(string: urlImage)
                    posterImageView.kf.setImage(with: posterURL)
                }
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM d, h:mm a"

                if let date = dateFormatterGet.date(from: news.publishedAt ?? "") {
                    dateLabel.text = "Date: \(dateFormatterPrint.string(from: date))"
                } else {
                   print("There was an error decoding the string")
                }
                if news.author?.hasPrefix("http") == false {
                    if let author = news.author {
                        authorLabel.text = author
                    }
                } else {
                    authorLabel.text = ""
                }
                titleText.text = news.title
                
                if let _ = CoreDataManager.shared.findNews(with: news.title!){
                    favouriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
                }else{
                    favouriteButton.setImage(UIImage(named: "star"), for: .normal)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true
        posterImageView.backgroundColor = .systemTeal
    }
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        if let news = news {
            if let _ = CoreDataManager.shared.findNews(with: news.title!) {
                CoreDataManager.shared.deleteNews(with: news.title!)
                sender.setImage(UIImage(named:"star"), for: .normal)
                delegate?.getAll()
            } else{
                CoreDataManager.shared.addNews(news)
                sender.setImage(UIImage(named: "starFilled"), for: .normal)
            }
        }
    }
    
}
