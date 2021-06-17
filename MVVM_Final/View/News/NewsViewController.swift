//
//  NewsViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 11.06.2021.
//

import UIKit
import Alamofire

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var news: [NewsModel.News] = [NewsModel.News]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var newsViewModel : NewsViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callNews()
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: Bundle(for: NewsTableViewCell.self)), forCellReuseIdentifier: NewsTableViewCell.identifier)
        self.callNews()
    }
}

extension NewsViewController {
   
    private func callNews() {
        self.newsViewModel = NewsViewModel()
        self.newsViewModel.bindNewsViewModelToController = {
            self.setupData()
        }
    }

    private func setupData() {
        self.news += self.newsViewModel.news
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(identifier: "NewsDetailsViewController") as? NewsDetailsViewController {
            vc.author = news[indexPath.row].author
            vc.descriptionText = news[indexPath.row].desc
            vc.date = news[indexPath.row].publishedAt
            vc.titleText = news[indexPath.row].title
            vc.imageUrl = news[indexPath.row].urlImage
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.news = news[indexPath.row]
        return cell
    }
}
