//
//  CitiesListTableViewCell.swift
//  MyWeather
//
//  Created by Illia Verezei on 20.11.2024.
//

import UIKit

class CitiesListTableViewCell: UITableViewCell {
  
  private var coordinates: CityCoordinates?
  
  lazy private var indicatorView = UIActivityIndicatorView(style: .medium)
  lazy private var roundedRectangleView = UIView()
  lazy private var cityLabel = UILabel()
  lazy private var weatherDescpitionLabel = UILabel()
  lazy private var tempLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupRoundedRectangleView(roundedRectangleView)
    setupTempLabel(tempLabel)
    setupCityLabel(cityLabel)
    setupWeahterDescpitionLabel(weatherDescpitionLabel)
    setupIndicator(indicatorView)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    cityLabel.text = nil
    tempLabel.text = nil
    weatherDescpitionLabel.text = nil
    removeBackgroundLayers(from: roundedRectangleView)
    indicatorView.stopAnimating()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupRoundedRectangleView(_ rectangle: UIView) {
    let layer = BackgroundManager().getBackground(for: nil, sunrise: nil, sunset: nil, frame: self.roundedRectangleView.bounds)
    rectangle.layer.insertSublayer(layer!, at: 0)
    rectangle.layer.cornerRadius = 24
    rectangle.layer.masksToBounds = true
    rectangle.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(rectangle)
    
    NSLayoutConstraint.activate([
      rectangle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      rectangle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      rectangle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      rectangle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  private func setupCityLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 40, weight: .regular)
    label.textColor = .white
    label.textAlignment = .left
    label.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: roundedRectangleView.leadingAnchor, constant: 16),
      label.topAnchor.constraint(equalTo: roundedRectangleView.topAnchor, constant: 26),
      label.trailingAnchor.constraint(equalTo: tempLabel.leadingAnchor, constant: -4)
    ])
  }
  
  private func setupTempLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 40, weight: .regular)
    label.textColor = .white
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: roundedRectangleView.centerXAnchor, constant: 80),
      label.topAnchor.constraint(equalTo: roundedRectangleView.topAnchor, constant: 20),
      label.trailingAnchor.constraint(equalTo: roundedRectangleView.trailingAnchor, constant: -16),
    ])
  }
  
  private func setupWeahterDescpitionLabel(_ label: UILabel) {
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.textColor = .white
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.trailingAnchor.constraint(equalTo: roundedRectangleView.trailingAnchor, constant: -16),
      label.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
      label.leadingAnchor.constraint(equalTo: tempLabel.leadingAnchor, constant: -48),
    ])
  }
  
  func setupIndicator(_ indicator: UIActivityIndicatorView) {
    indicator.color = .systemGray
    indicator.hidesWhenStopped = true
    indicator.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(indicator)
    
    NSLayoutConstraint.activate([
      indicator.trailingAnchor.constraint(equalTo: roundedRectangleView.trailingAnchor, constant: -16),
      indicator.centerYAnchor.constraint(equalTo: self.cityLabel.centerYAnchor)
    ])
    
    indicator.startAnimating()
  }
  
  func removeBackgroundLayers(from view: UIView) {
    view.layer.sublayers?.forEach { layer in
      if layer is CAGradientLayer {
        layer.removeFromSuperlayer()
      }
    }
  }
  
  func configure(coordinates: CityCoordinates, indexPath: IndexPath, tableView: UITableView) {
    self.coordinates = coordinates
    if coordinates.name.count >= 10 {
      cityLabel.font = .systemFont(ofSize: 32, weight: .regular)
    } else {
      cityLabel.font = .systemFont(ofSize: 40, weight: .regular)
    }
    
    cityLabel.text = coordinates.name
    
    removeBackgroundLayers(from: roundedRectangleView)
    roundedRectangleView.setNeedsLayout()
    
    
    
    WebManager.shared.fetchTempNow(for: coordinates) { result in
      DispatchQueue.main.async {
        
        guard let currentCell = tableView.cellForRow(at: indexPath) as? CitiesListTableViewCell,
              currentCell === self else {
          return
        }
        
        switch result {
        case .success(let success):
          self.tempLabel.text = String(Int(success.main.temp.rounded())) + "°"
          self.tempLabel.setNeedsLayout()
          
          self.weatherDescpitionLabel.text = success.weather.first?.description.capitalizeFirstWord()
          
          let layer = BackgroundManager().getBackground(for: success.weather.first?.id, sunrise: success.sys.sunrise, sunset: success.sys.sunset , frame: self.roundedRectangleView.bounds)
          self.roundedRectangleView.layer.insertSublayer(layer!, at: 0)
          self.indicatorView.stopAnimating()
        case .failure(let failure):
          print(failure)
          self.indicatorView.startAnimating()
        }
      }
    }
  }
}
