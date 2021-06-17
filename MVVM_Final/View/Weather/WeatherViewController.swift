//
//  WeatherViewController.swift
//  MVVM_Final
//
//  Created by Kuanyshbay Ibragim on 12.06.2021.
//

import UIKit
import Alamofire

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
    
    private var weatherViewModel: WeatherViewModel!
    
    var weather: WeatherModel? {
        didSet {
            
            if let timezone = weather?.timezone {
                let currentDate = Date()
                let format = DateFormatter()
                format.timeZone = TimeZone(secondsFromGMT: timezone)
                format.dateFormat = "MMM d, h:mm a"
                let dateString = format.string(from: currentDate)
                timeLabel.text = "Time: \(dateString)"
            }
            if let name = weather?.name {
                cityNameLabel.text = name
            }
            
            if let temp = weather?.main?.temp {
                tempLabel.text = "Now: \(temp) ˚C"
            }
            
            if let feels_like = weather?.main?.feels_like {
                feelsLikeTempLabel.text = "Feels like: \(feels_like) ˚C"
            }
            
            if let main = weather?.weather.first?.main {
                descLabel.text = main
            }
            
            if let wind = weather?.wind?.speed {
                windLabel.text = "Wind: \(wind) m/s"
            }
            
            if let visibility = weather?.visibility {
                visibilityLabel.text = "Visibility: \(visibility/1000.0) km"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.callWeather("Astana")
        findButton.layer.cornerRadius = 5
        findButton.layer.borderWidth = 1
        findButton.layer.borderColor = UIColor.orange.cgColor
    }
    
    @IBAction func findButtonPressed(_ sender: Any) {
        guard let city = cityTextField.text else { return }
        self.callWeather(city)
    }
}
extension WeatherViewController {
    
   private func callWeather(_ city: String) {
        self.weatherViewModel = WeatherViewModel(city)
        self.weatherViewModel.bindWeatherViewModelToController = {
            self.setupData()
        }
    }
    
   private func setupData() {
        self.weather = self.weatherViewModel.weather
    }
}
