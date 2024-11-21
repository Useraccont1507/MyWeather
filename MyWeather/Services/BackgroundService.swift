//
//  BackgroundService.swift
//  MyWeather
//
//  Created by Illia Verezei on 21.11.2024.
//

import Foundation
import UIKit

class BackgroundManager {
  private enum Weather {
    case clear
    case cloudsFogSnow
  }
  
  private func decodeUnixToGMTTime(_ date: Int) -> Date {
    let unixTimestamp: TimeInterval = TimeInterval(date)
    let date = Date(timeIntervalSince1970: unixTimestamp)
    return date
  }
  
  func getBackgroundSmall(sunrise: Int, sunset: Int, weatherCode: Int) -> UIImage? {
    let timeOfDay = Date.now
    let sunriseGMT = decodeUnixToGMTTime(sunrise)
    let sunsetGMT = decodeUnixToGMTTime(sunset)
    var weather: Weather = .clear
    
    switch weatherCode {
    case 800 : weather = .clear
    case 801...804 : weather = .cloudsFogSnow
    case 700...781 : weather = .cloudsFogSnow
    case 600...622 : weather = .cloudsFogSnow
    case 500...531 : weather = .cloudsFogSnow
    default: break
    }
    
    if timeOfDay > sunriseGMT.addingTimeInterval(-3600) && timeOfDay < sunriseGMT.addingTimeInterval(3600) {
      switch weather {
      case .clear:
        return UIImage(named: "СlearMorningS")
      case .cloudsFogSnow:
        return UIImage(named: "CloudFogSnowMorningS")
      }
    } else if timeOfDay < sunsetGMT.addingTimeInterval(-3600) && timeOfDay > sunriseGMT.addingTimeInterval(3600) {
      switch weather {
      case .clear:
        return UIImage(named: "ClearAfternoonS")
      case .cloudsFogSnow:
        return UIImage(named: "CloudFogSnowAfternoonS")
      }
    } else if timeOfDay > sunsetGMT.addingTimeInterval(-3600) && timeOfDay < sunsetGMT.addingTimeInterval(3600) {
      switch weather {
      case .clear:
        return UIImage(named: "ClearEveningS")
      case .cloudsFogSnow:
        return UIImage(named: "CloudEveningS")
      }
    } else {
      switch weather {
      case .clear:
        return UIImage(named: "NightS")
      case .cloudsFogSnow:
        return UIImage(named: "NightS")
      }
    }
  }
}
