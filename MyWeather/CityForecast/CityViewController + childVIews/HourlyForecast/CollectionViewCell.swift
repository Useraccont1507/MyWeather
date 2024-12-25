//
//  CollectionViewCell.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  lazy private var timeLabel = UILabel()
  lazy private var weatherIcon = UILabel()
  lazy private var tempLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupWeatherIcon(weatherIcon)
    setupTempLabel(tempLabel)
    setupTimeLabel(timeLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTimeLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: weatherIcon.topAnchor, constant: -8),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  private func setupWeatherIcon(_ label: UILabel) {
    label.text = "-"
    label.font = .systemFont(ofSize: 28, weight: .regular)
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func setupTempLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 20, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  func configure(time: Int, timezone: TimeZone?, weatherIcon: String, temp: Double) {
    self.weatherIcon.text = WeatherIconManager().getIcon(with: weatherIcon)
    
    self.tempLabel.text = String(Int(temp.rounded())) + "°"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let timeManager = TimeManager()
    dateFormatter.timeZone = timezone
    let text = dateFormatter.string(from: timeManager.decodeUnixToGMTTime(time))
    self.timeLabel.text = text
  }
}
