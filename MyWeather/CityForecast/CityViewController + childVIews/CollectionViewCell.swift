//
//  CollectionViewCell.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  lazy private var timeLabel = UILabel()
  lazy private var humidityLabel = UILabel()
  lazy private var weatherIcon = UIImageView()
  lazy private var tempLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupWeatherIcon(weatherIcon)
    setupHumidityLabel(humidityLabel)
    setupTempLabel(tempLabel)
    setupTimeLabel(timeLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTimeLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 20, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: humidityLabel.topAnchor, constant: -4),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
    ])
  }
  
  private func setupHumidityLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 16, weight: .light)
    label.textColor = .clear
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: weatherIcon.topAnchor, constant: 8),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  private func setupWeatherIcon(_ imageView: UIImageView) {
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 54),
      imageView.heightAnchor.constraint(equalToConstant: 54),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 16)
    ])
  }
  
  private func setupTempLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 12),
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
  func configure(time: Int, humidity: Double, weatherId: Int, temp: Double) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let text = dateFormatter.string(from: Date.now)
    timeLabel.text = text
    humidityLabel.text = "80%"
    weatherIcon.image = UIImage(named: "ImageRain")
    tempLabel.text = "15"
    //TODO: realization
  }
}
