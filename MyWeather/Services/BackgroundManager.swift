//
//  BackgroundService.swift
//  MyWeather
//
//  Created by Illia Verezei on 21.11.2024.
//

import Foundation
import UIKit

class BackgroundManager {
  
  func getBackground(for weatherCode: Int?, sunrise: Int?, sunset: Int?, frame: CGRect) -> CAGradientLayer? {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    
    if let sunrise = sunrise,
       let sunset = sunset,
       let weatherCode = weatherCode {
      let timeOfDay = Date.now
      let sunriseGMT = TimeManager().decodeUnixToGMTTime(sunrise)
      let sunsetGMT = TimeManager().decodeUnixToGMTTime(sunset)
      let isDay = timeOfDay > sunriseGMT.addingTimeInterval(-1800) && timeOfDay < sunsetGMT.addingTimeInterval(1800)
      
      // Apple Weather-inspired gradients
      switch weatherCode {
      case 200...232: // Thunderstorm
        gradientLayer.colors = isDay
        ? [UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor, UIColor(red: 1, green: 0.8, blue: 0.3, alpha: 1).cgColor]
        : [UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1).cgColor, UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1).cgColor]
      case 300...321: // Drizzle
        gradientLayer.colors = isDay
        ? [UIColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 1).cgColor, UIColor.white.cgColor]
        : [UIColor(red: 0.4, green: 0.5, blue: 0.6, alpha: 1).cgColor, UIColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 1).cgColor]
      case 500...531: // Rain
        gradientLayer.colors = isDay
        ? [UIColor(red: 0.5, green: 0.6, blue: 0.9, alpha: 1).cgColor, UIColor(red: 0.3, green: 0.4, blue: 0.6, alpha: 1).cgColor]
        : [UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1).cgColor, UIColor.black.cgColor]
      case 600...622: // Snow
        gradientLayer.colors = isDay
        ? [
          UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor,
          UIColor(red: 0.7, green: 0.7, blue: 0.8, alpha: 1).cgColor]
        : [UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1).cgColor, UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1).cgColor]
      case 800: // Clear
        gradientLayer.colors = isDay
        ? [UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1).cgColor, UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1).cgColor]
        : [UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1).cgColor, UIColor.black.cgColor]
      case 801...804: // Clouds
        gradientLayer.colors = isDay
        ? [UIColor(red: 0.6, green: 0.7, blue: 0.8, alpha: 1).cgColor, UIColor(red: 0.8, green: 0.8, blue: 0.9, alpha: 1).cgColor]
        : [UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1).cgColor, UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1).cgColor]
      default:
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.gray.cgColor]
      }
    } else {
      gradientLayer.colors = [UIColor.white.cgColor, UIColor.gray.cgColor]
    }
    
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0, y: 1)
    gradientLayer.locations = [0.0, 1.0]
    
    return gradientLayer
  }
}
