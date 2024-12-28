//
//  LoadingView.swift
//  MyWeather
//
//  Created by Illia Verezei on 28.12.2024.
//

import UIKit

import UIKit

class LoadingView: UIView {
  
  private lazy var backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    view.layer.cornerRadius = 10
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .white
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  private lazy var messageLabel: UILabel = {
    let label = UILabel()
    label.text = "loading".localized
    label.textColor = .white
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  private func setupUI() {
    self.backgroundColor = UIColor(white: 0, alpha: 0.4)
    
    addSubview(backgroundView)
    backgroundView.addSubview(activityIndicator)
    backgroundView.addSubview(messageLabel)
    
    NSLayoutConstraint.activate([
      backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      backgroundView.widthAnchor.constraint(equalToConstant: 150),
      backgroundView.heightAnchor.constraint(equalToConstant: 120),
      
      activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
      activityIndicator.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
      
      messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
      messageLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
      messageLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10)
    ])
    
    activityIndicator.startAnimating()
  }
}
