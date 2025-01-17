//
//  WeatherIconService.swift
//  MyWeather
//
//  Created by Illia Verezei on 23.12.2024.
//

import Foundation
import UIKit

protocol WeatherIconManagerProtocol {
  func getIcon(with weatherCode: String) -> UIImage?
}

final class WeatherIconManager: WeatherIconManagerProtocol {
  
  func getIcon(with weatherCode: String) -> UIImage? {
    switch weatherCode {
    case "01d": return UIImage(systemName: "sun.max.fill")
    case "01n": return UIImage(systemName: "moon.stars.fill")
    case "02d": return UIImage(systemName: "cloud.sun.fill")
    case "02n": return UIImage(systemName: "cloud.moon.fill")
    case "03d", "03n": return UIImage(systemName: "cloud.fill")
    case "04d", "04n": return UIImage(systemName: "smoke.fill")
    case "09d", "09n": return UIImage(systemName: "cloud.hail.fill")
    case "10d": return UIImage(systemName: "cloud.sun.rain.fill")
    case "10n": return UIImage(systemName: "cloud.moon.rain.fill")
    case "11d": return UIImage(systemName: "cloud.moon.bolt.fill")
    case "11n": return UIImage(systemName: "cloud.sun.bolt.fill")
    case "13d", "13n": return UIImage(systemName: "snowflake")
    case "50d", "50n": return UIImage(systemName: "aqi.medium")
    default:
      return UIImage(systemName: "sun.max.fill")
    }
  }
}
