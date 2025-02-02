//
//  CollectionViewCell.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  lazy private var timeLabel = UILabel()
  lazy private var weatherIcon = UIImageView()
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
  
  private func setupWeatherIcon(_ imageView: UIImageView) {
    imageView.contentMode = .scaleToFill
    imageView.tintColor = .white
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: 26),
      imageView.widthAnchor.constraint(equalToConstant: 30),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func setupTempLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 20, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 8),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  func configure(time: Int, timezone: TimeZone?, weatherIcon: String, temp: Double) {
    self.weatherIcon.image = WeatherIconManager().getIcon(with: weatherIcon)
    
    self.tempLabel.text = String(Int(temp.rounded())) + "°"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let timeManager = TimeManager()
    dateFormatter.timeZone = timezone
    let text = dateFormatter.string(from: timeManager.decodeUnixToGMTTime(time))
    self.timeLabel.text = text
  }
}
