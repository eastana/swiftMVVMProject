//
//  CoreDataManager.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LocalDBModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func save() {
        let context = persistentContainer.viewContext
        do {
            try context.save()
        } catch  {
            print(error)
        }
    }
    
    func addNews(_ news: NewsModel.News) {
        let context = persistentContainer.viewContext
        context.perform {
            let newNews = NewsEntity(context: context)
            newNews.author = news.author
            newNews.date = news.publishedAt
            newNews.title = news.title
            newNews.image = news.urlImage
            newNews.desc = news.desc
        }
        save()
    }
    
    func findNews(with title : String) -> NewsEntity? {
        let context = persistentContainer.viewContext
        let requestResult : NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
        requestResult.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let news = try context.fetch(requestResult)
            if news.count > 0 {
                assert(news.count == 1 , "It means DB has duplicates")
                return news[0]
            }
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    func deleteNews(with title : String){
        let context = persistentContainer.viewContext
        
        let news = findNews(with: title)
        
        if let news = news{
            context.delete(news)
            save()
        }
        
    }
    
    func allNews() -> [NewsModel.News] {
        let context = persistentContainer.viewContext
        let request : NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
        
        let news = try? context.fetch(request)
        return news?.map ({ NewsModel.News(news: $0) }) ?? []
        
    }
    
    func clearDatabase() {
        guard let url = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        
        let persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print("Attempted to clear persistent store: " + error.localizedDescription)
        }
    }
}
