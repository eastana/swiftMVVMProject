//
//  WeatherViewModel.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 13.06.2021.
//

import Foundation

class WeatherViewModel: NSObject {
    private var apiService : ApiService!
    private(set) var weather: WeatherModel! {
        didSet {
            self.bindWeatherViewModelToController()
        }
    }
    
    var bindWeatherViewModelToController : (() -> ()) = {}
    
    init(_ city: String) {
        super.init()
        self.apiService = ApiService()
        self.callFuncToGetWeatherData(city)
    }
    
    func callFuncToGetWeatherData(_ city: String) {
        self.apiService.getWeatherAPI(city: city) { (weather) in
            self.weather = weather
        }
    }
}
