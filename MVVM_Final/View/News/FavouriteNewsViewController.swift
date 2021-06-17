//
//  FavouriteNewsViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import UIKit

class FavouriteNewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var news: [NewsModel.News] = [] {
        didSet{
            if news.count != oldValue.count{
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: Bundle(for: NewsTableViewCell.self)), forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        news = CoreDataManager.shared.allNews()
    }

}
extension FavouriteNewsViewController: UITableViewDelegate , UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        as! NewsTableViewCell
        let new = news[indexPath.row]
        cell.news = new
        cell.delegate = self
        return cell
    }
}
extension FavouriteNewsViewController: NewsTableViewCellGetAllProtocol {
    func getAll() {
        news = CoreDataManager.shared.allNews()
    }
}
