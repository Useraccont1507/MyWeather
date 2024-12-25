//
//  WeatherIconService.swift
//  MyWeather
//
//  Created by Illia Verezei on 23.12.2024.
//

import Foundation
import UIKit

class WeatherIconManager {
  
  func getIcon(with weatherCode: String) -> String {
    switch weatherCode {
    case "01d": return "☀️"
    case "01n": return "🌑"
    case "02d": return "⛅️"
    case "02n": return "☁️"
    case "03d", "03n", "04d", "04n": return "☁️"
    case "09d", "09n", "10d", "10n": return "🌧️"
    case "11d", "11n": return "🌩️"
    case "13d", "13n": return "❄️"
    case "50d", "50n": return "💨"
    default:
      return "01n"
    }
  }
}
