//
//  NewsViewModel.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation

class NewsViewModel: NSObject {
    private var apiService : ApiService!
    private(set) var news: [NewsModel.News] = [NewsModel.News]() {
        didSet {
            self.bindNewsViewModelToController()
        }
    }
    var bindNewsViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService = ApiService()
        self.callFuncToGetNewsData()
    }
    
    func callFuncToGetNewsData() {
        self.apiService.getNewsAPI() { (news) in
            self.news += news.articles
        }
    }
}
