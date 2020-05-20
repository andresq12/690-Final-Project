//
//  WeatherModel.swift
//  WeatherAppAPI
//
//  Created by MacBook Pro on 5/16/20.
//  Copyright © 2020 Andres Quinonez. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    //Switch statement which changes the icon depending on the conditionid json value we retrieve
    var conditionName: String{
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "smoke"
        default:
            return "cloud"
        }

    }
    
}
