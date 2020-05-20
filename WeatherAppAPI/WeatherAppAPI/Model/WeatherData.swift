//
//  WeatherData.swift
//  WeatherAppAPI
//
//  Created by MacBook Pro on 5/16/20.
//  Copyright © 2020 Andres Quinonez. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable{
    let id: Int
}


