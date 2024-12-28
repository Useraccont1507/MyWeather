//
//  WeatherDescriprion.swift
//  MyWeather
//
//  Created by Illia Verezei on 22.12.2024.
//

import UIKit

class WeatherDescriprionView: UIView {
  
  lazy private var weatherIcon = UIImageView()
  lazy private var weatherDescriprionLabel = UILabel()
  lazy private var tempLabel = UILabel()
  lazy private var separatorView = UIView()
  lazy private var sunriseLabel = UILabel()
  lazy private var sunriseImageView = UIImageView()
  lazy private var sunsetLabel = UILabel()
  lazy private var sunsetImageView = UIImageView()
  
  init() {
    super.init(frame: .zero)
    setupWeatherIcon(weatherIcon)
    setupWeatherDescriprionLabel(weatherDescriprionLabel)
    setupTempLabel(tempLabel)
    setupSeparatorView(separatorView)
    setupSunriseImageView(sunriseImageView)
    setupSunriseLabel(sunriseLabel)
    setupSunsetImageView(sunsetImageView)
    setupSunsetLabel(sunsetLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupWeatherIcon(_ imageView: UIImageView) {
    imageView.contentMode = .scaleToFill
    imageView.tintColor = .white
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.heightAnchor.constraint(equalToConstant: 40),
      imageView.widthAnchor.constraint(equalToConstant: 50),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
    ])
  }
  
  private func setupWeatherDescriprionLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 28, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: weatherIcon.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 4)
    ])
  }
  
  private func setupTempLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 120, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor),
      label.leadingAnchor.constraint(equalTo: leadingAnchor)
    ])
  }
  
  private func setupSunriseLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: sunriseImageView.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: sunriseImageView.trailingAnchor, constant: 8)
    ])
  }
  
  private func setupSunriseImageView(_ imageView: UIImageView) {
    imageView.image = UIImage(systemName: "sunrise.fill")
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 24),
      imageView.heightAnchor.constraint(equalToConstant: 24),
      imageView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -4),
      imageView.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 4)
    ])
  }
  
  private func setupSeparatorView(_ separator: UIView) {
    separator.backgroundColor = .white
    separator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(separator)
    
    NSLayoutConstraint.activate([
      separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      separator.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
      separator.widthAnchor.constraint(equalToConstant: 92),
      separator.heightAnchor.constraint(equalToConstant: 2)
    ])
  }
  
  private func setupSunsetLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerYAnchor.constraint(equalTo: sunsetImageView.centerYAnchor),
      label.leadingAnchor.constraint(equalTo: sunsetImageView.trailingAnchor, constant: 8)
    ])
  }
  
  private func setupSunsetImageView(_ imageView: UIImageView) {
    imageView.image = UIImage(systemName: "sunset.fill")
    imageView.tintColor = .white
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 24),
      imageView.heightAnchor.constraint(equalToConstant: 24),
      imageView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 4),
      imageView.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 4)
    ])
  }
  
  func configure(icon: String, description: String, temp: Double, timezone: Int, sunrise: Int?, sunset: Int?) {
    self.weatherIcon.image = WeatherIconManager().getIcon(with: icon)
    
    self.weatherDescriprionLabel.text = description.capitalizeFirstWord()
    
    self.tempLabel.text = String(Int(temp.rounded())) + "°"
    
    
    let timeManager = TimeManager()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
    dateFormatter.dateFormat = "HH:mm"
    let sunriseDate = timeManager.decodeUnixToGMTTime(sunrise ?? 0)
    let sunsetDate = timeManager.decodeUnixToGMTTime(sunset ?? 0)
    let sunriseString = dateFormatter.string(from: sunriseDate)
    let sunsetString = dateFormatter.string(from: sunsetDate)
    self.sunriseLabel.text = sunriseString
    self.sunsetLabel.text = sunsetString
  }
}

