//
//  ApiService.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 07.06.2021.
//

import Foundation
import Alamofire
import Firebase
import FirebaseStorage

class ApiService: NSObject {
    
    private var GET_TOP_NEWS_URL =
        "https://newsapi.org/v2/top-headlines?language=en&apiKey=XXXXXXXXX"
    private var GET_WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather?q="
    private var WEATHER_API = "&appid=XXXXXXXXX&units=metric"
    private var messagesDB = Database.database().reference().child("Messages")
    
    func getNewsAPI(completion : @escaping (NewsModel) -> ()) {
        AF.request(GET_TOP_NEWS_URL, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                    let newsJSON = try JSONDecoder().decode(NewsModel.self, from: data)
                        completion(newsJSON)
                    }
                    catch let e {
                        print(e)
                    }
                }
                break
            case .failure:
                print("failed to retrive data")
            }
        }
    }
    
    func getWeatherAPI(city: String, completion : @escaping (WeatherModel) -> ()) {
        let FULL_URL = GET_WEATHER_URL + city + WEATHER_API
        AF.request(FULL_URL, method: .get).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.data {
                    do {
                    let weatherJSON = try JSONDecoder().decode(WeatherModel.self, from: data)
                        completion(weatherJSON)
                    }
                    catch let e {
                        print(e)
                    }
                }
            case .failure(let err):
                print(err.errorDescription ?? "")
            }
        }
    }
    
    func fetchMessagesFromFirebase(completion : @escaping (MessageEntity) -> ()) {
        messagesDB.observe(.childAdded) { (snapshot) in
            if let values = snapshot.value as? [String: String] {
                guard let message = values["message"] else { return }
                guard let sender = values["sender"] else { return }
                completion(MessageEntity(message: message, sender: sender))
            }
        }
    }
    
    func sendMessageToFirebase(message: String, completion: @escaping (String) -> ()) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let messagesDict = ["sender": email, "message": message]
        messagesDB.childByAutoId().setValue(messagesDict) { (error, reference) in
            if error != nil {
                completion("It has error")
            } else {
                completion("No error")
            }
        }
    }
    
    func loginWithFirebase(email: String, password: String, completion: @escaping (String) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!)
                completion("It has error")
            } else {
                completion("No error")
            }
        }
    }
    
    func registrationWithFirebase(email: String, password: String, completion: @escaping (String) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) {(result, error) in
            if error != nil {
                print(error!)
                completion("It has error")
            } else {
                completion("No error")
            }
        }
    }
    
    func logoutWithFirebase(completion: @escaping (String) -> ()) {
        do {
            try Auth.auth().signOut()
            completion("No error")
        } catch {
            completion("It has error")
        }
    }
    
}
