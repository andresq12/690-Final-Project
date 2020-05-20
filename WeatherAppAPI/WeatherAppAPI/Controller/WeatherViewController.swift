//
//  ViewController.swift
//  WeatherAppAPI
//
//  Created by MacBook Pro on 5/15/20.
//  Copyright © 2020 Andres Quinonez. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var degreesLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
        
    var temp = 0.0000000
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //text field reports back to the view controller
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    //Changes the url to fetch data in celsius or farenheight
    //Changes the label and converts the degrees displayed to requested degree system
    @IBAction func degressPressed(_ sender: UIButton) {
        if degreesLabel.text == "F" && weatherManager.weatherURL == "https://api.openweathermap.org/data/2.5/weather?appid=9e677fea05fcbca704637195dd957baf&units=imperial"{
            temp = Double(self.temperatureLabel.text!)!
            temp = (temp - 32) * (5/9)
            self.temperatureLabel.text = String(format: "%.1f", temp)
            degreesLabel.text = "C"
        }else if degreesLabel.text == "C" && weatherManager.weatherURL == "https://api.openweathermap.org/data/2.5/weather?appid=9e677fea05fcbca704637195dd957baf&units=metric"{
            temp = Double(self.temperatureLabel.text!)!
            temp = (temp * (9/5)) + 32
            self.temperatureLabel.text = String(format: "%.1f", temp)
            degreesLabel.text = "F"
        }
        weatherManager.changeURL()
    }
    
    
}


//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
     }
    //allows the return button on the keyboard to act as the search pressed key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type a city here"
            return false
        }
    }
    
    //clears the search bar after you hit go or the search icon
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
        }
        
        func didFailWithError(error: Error){
            print(error)
        }
    }

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

