//
//  Weather.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 12.06.2021.
//

import Foundation


struct WeatherModel: Decodable {
    
    let weather: [Weather]
    let main: Main?
    let visibility: Double?
    let wind: Wind?
    let name: String?
    let timezone: Int?
    
    struct Weather: Decodable {
        let main: String?
        
        enum CodingKeys: String, CodingKey {
            case main
        }
    }
    
    struct Main: Decodable {
        let temp: Double?
        let feels_like: Double?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feels_like
        }
    }
    
    struct Wind: Decodable {
        let speed: Double?
        
        enum CodingKeys: String, CodingKey {
            case speed
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case wind
        case visibility
        case name
        case timezone
    }
}
