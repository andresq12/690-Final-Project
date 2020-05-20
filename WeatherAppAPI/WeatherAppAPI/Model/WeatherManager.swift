//
//  WeatherManager.swift
//  WeatherAppAPI
//
//  Created by MacBook Pro on 5/16/20.
//  Copyright © 2020 Andres Quinonez. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9e677fea05fcbca704637195dd957baf&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        //tokenizes city name and checks if there is a space, and if so then changes urlstring to appropriate url seperation
        let whitespace = " "
        if cityName.range(of: whitespace) != nil{
            let cityNameARR = cityName.components(separatedBy: " ")
            let firstPart: String = cityNameARR[0]
            let secondPart: String = cityNameARR[1]
            let urlString = "\(weatherURL)&q=\(firstPart)%20\(secondPart)"
            performRequest(with: urlString)
            print(urlString)
        }else{
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        print(urlString)
            }
    }
    //checks weather with location in terms of logitude and latitude
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees ){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)

    }
    
    //changes url so that if the function is called it will search for imperial or metric depending on the link
    mutating func changeURL(){
        if weatherURL == "https://api.openweathermap.org/data/2.5/weather?appid=9e677fea05fcbca704637195dd957baf&units=imperial" {
            weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9e677fea05fcbca704637195dd957baf&units=metric"
            
        }else {
            weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9e677fea05fcbca704637195dd957baf&units=imperial"
        }
        
    }
    
    func performRequest(with urlString: String){
        //creates a url
        if let url = URL(string: urlString){
            //takes url and starts a session
            let session = URLSession(configuration: .default)
            //gives that session a task with an anonymous function
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather =  self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
                
                task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

