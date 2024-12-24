//
//  TimeManager.swift
//  MyWeather
//
//  Created by Illia Verezei on 24.12.2024.
//

import Foundation

class TimeManager {
  /// A dictionary mapping country codes to their corresponding time zone identifiers.
  private let timeZoneMapping: [String: String] = [
    "US": "America/New_York",  // United States (Eastern Time Zone as default)
    "CA": "America/Toronto",   // Canada
    "MX": "America/Mexico_City", // Mexico
    "GB": "Europe/London",     // United Kingdom
    "FR": "Europe/Paris",      // France
    "DE": "Europe/Berlin",     // Germany
    "IT": "Europe/Rome",       // Italy
    "PL": "Europe/Warsaw",     // Poland
    "UA": "Europe/Kyiv",       // Ukraine
    "RU": "Europe/Moscow",     // Russia (European part)
    "CN": "Asia/Shanghai",     // China
    "JP": "Asia/Tokyo",        // Japan
    "IN": "Asia/Kolkata",      // India
    "AU": "Australia/Sydney",  // Australia
    "NZ": "Pacific/Auckland",  // New Zealand
    "BR": "America/Sao_Paulo", // Brazil
    "AR": "America/Argentina/Buenos_Aires", // Argentina
    "ZA": "Africa/Johannesburg", // South Africa
    "EG": "Africa/Cairo",      // Egypt
    "TR": "Europe/Istanbul",   // Turkey
    "SA": "Asia/Riyadh",       // Saudi Arabia
    "KR": "Asia/Seoul"         // South Korea
  ]
  
  /// This function retrieves the time zone identifier based on the country code.
  /// - Parameter countryCode: The country code (e.g., "US", "UA", "PL").
  /// - Returns: The corresponding time zone identifier (e.g., "America/New_York") or nil if no match is found.
  func getTimeZoneIdentifier(for countryCode: String) -> String {
    return timeZoneMapping[countryCode] ?? timeZoneMapping["GB"]!
  }
  
  func decodeUnixToGMTTime(_ date: Int) -> Date {
    let unixTimestamp: TimeInterval = TimeInterval(date)
    let date = Date(timeIntervalSince1970: unixTimestamp)
    return date
  }
}
