//
//  News.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 11.06.2021.
//

import Foundation

struct NewsModel: Decodable {
    let articles: [News]
    
    struct News: Decodable {
        let author: String?
        let title: String?
        let desc: String?
        let urlImage: String?
        let publishedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case author
            case title
            case desc = "description"
            case urlImage = "urlToImage"
            case publishedAt
        }
        
        init(news: NewsEntity) {
            self.author = news.author
            self.title = news.title
            self.desc = news.desc
            self.urlImage = news.image
            self.publishedAt = news.date
        }
    }
}
