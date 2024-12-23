//
//  String + extension.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import Foundation

extension String {
  var localized: String {
    NSLocalizedString(self, comment: "\(self) could not be found in Localizable.string")
  }
  
  func localizedPlural(_ arg: Int) -> String {
    let formatString = NSLocalizedString(self, comment: "\(self) could not be found in Localizable.stringdict")
    return Self.localizedStringWithFormat(formatString, arg)
  }
  
  func capitalizeFirstWord() -> String {
    guard let firstChar = self.first else { return self }
    return firstChar.uppercased() + self.dropFirst()
  }
}
