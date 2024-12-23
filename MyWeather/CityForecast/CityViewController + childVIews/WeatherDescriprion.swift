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
  lazy private var maxTempLabel = UILabel()
  lazy private var minTempLabel = UILabel()
  
  init() {
    super.init(frame: .zero)
    setupWeatherIcon(weatherIcon)
    setupWeatherDescriprionLabel(weatherDescriprionLabel)
    setupTempLabel(tempLabel)
    setupSeparatorView(separatorView)
    setupMaxLabel(maxTempLabel)
    setupMinLabel(minTempLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupWeatherIcon(_ imageView: UIImageView) {
    imageView.image = UIImage(systemName: "clock")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 64),
      imageView.heightAnchor.constraint(equalToConstant: 64),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
    ])
  }
  
  private func setupWeatherDescriprionLabel(_ label: UILabel) {
    label.text = "--"
    label.font = .systemFont(ofSize: 28, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      label.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 4)
    ])
  }
  
  private func setupTempLabel(_ label: UILabel) {
    label.text = "--°"
    label.font = .systemFont(ofSize: 120, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: weatherDescriprionLabel.bottomAnchor),
      label.leadingAnchor.constraint(equalTo: leadingAnchor)
    ])
  }
  
  private func setupMaxLabel(_ label: UILabel) {
    label.text = "max --°"
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -8),
      label.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 4)
    ])
  }
  
  private func setupSeparatorView(_ separator: UIView) {
    separator.backgroundColor = .lightGray
    separator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(separator)
    
    NSLayoutConstraint.activate([
      separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      separator.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
      separator.widthAnchor.constraint(equalToConstant: 72),
      separator.heightAnchor.constraint(equalToConstant: 2)
    ])
  }
  
  private func setupMinLabel(_ label: UILabel) {
    label.text = "min --°"
    label.font = .systemFont(ofSize: 18, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
      label.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 4)
    ])
  }
  
  func configure(_ city: CityCoordinates?) {
    guard let city = city else { return }
    WebManager.shared.fetchTempNow(for: city) { result in
      switch result {
      case .success(let success):
        DispatchQueue.main.async {
          self.weatherDescriprionLabel.text = success.weather.first?.description.capitalizeFirstWord()
          self.tempLabel.text = String(Int(success.main.temp.rounded())) + "°"
          
          let sunrise = success.sys.sunrise
          let sunset = success.sys.sunset
          let weatherCode = success.weather.first!.icon
          
          
          WeatherIconManager().getIcon(with: weatherCode, sunrise: sunrise, sunset: sunset) { result in
            switch result {
            case .success(let success):
              DispatchQueue.main.async {
                self.weatherIcon.image = success
              }
            case .failure(let failure):
              print(failure)
            }
          }
        }
      case .failure(let failure):
        print(failure)
      }
    }
  }
}
