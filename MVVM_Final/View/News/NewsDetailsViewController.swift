//
//  NewsDetailsViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import UIKit
import Kingfisher

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    public var date: String?
    public var author: String?
    public var titleText: String?
    public var descriptionText: String?
    public var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupDateFormat()
        setupAuthor()
        setupImage()
        titleLabel.text = titleText
        descriptionTextView.text = descriptionText
        
    }
    
    private func setupDateFormat() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, h:mm a"
        
        if let date = dateFormatterGet.date(from: date ?? "") {
            dateLabel.text = "Date: \(dateFormatterPrint.string(from: date))"
        } else {
           print("There was an error decoding the string")
        }
    }
    
    private func setupAuthor() {
        if author?.hasPrefix("http") == false && author?.hasSuffix("com") == false{
            if let author = author {
                authorLabel.text = author
            }
        } else {
            authorLabel.text = ""
        }
    }
    
    private func setupImage() {
        if let url = imageUrl {
            var urlImage: String!
            if url.isEmpty == false {
                urlImage = url
            } else {
                urlImage = "http://godsanswermodelcollege.com.ng/private/images/default_news.jpg"
            }
            let posterURL = URL(string: urlImage)
            imageView.kf.setImage(with: posterURL)
        }
    }
}
