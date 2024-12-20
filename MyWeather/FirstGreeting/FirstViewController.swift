//
//  ViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class FirstViewController: UIViewController {

  lazy private var mainGreetingLabel = UILabel()
  lazy private var secondaryGreetingLabel = UILabel()
  lazy private var cityImageView = UIImageView()
  lazy private var beginButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupSecondaryGreetingLabel(secondaryGreetingLabel)
    setupMainGreetingLabel(mainGreetingLabel)
    setupCityImageView(cityImageView)
    setupBeginButton(beginButton)
  }
  
  private func setupMainGreetingLabel(_ label: UILabel) {
    label.text = "main_greeting".localized
    label.font = .systemFont(ofSize: 32, weight: .bold)
    label.textColor = .black
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.bottomAnchor.constraint(equalTo: secondaryGreetingLabel.topAnchor),
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.widthAnchor.constraint(equalToConstant: 272),
      label.heightAnchor.constraint(equalToConstant: 42)
    ])
  }
  
  private func setupSecondaryGreetingLabel(_ label: UILabel) {
    label.text = "secondary_greeting".localized
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
      label.widthAnchor.constraint(equalToConstant: 280),
      label.heightAnchor.constraint(equalToConstant: 68)
    ])
  }
  
  private func setupCityImageView(_ imageView: UIImageView) {
    imageView.contentMode = .scaleToFill
    imageView.image = UIImage(named: "CityImage")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: secondaryGreetingLabel.bottomAnchor, constant: 8),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 104)
    ])
  }
  
  private func setupBeginButton(_ button: UIButton) {
    button.setTitle("select_button_text".localized, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 24
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(moveToSeacrh), for: .touchUpInside)
    view.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.widthAnchor.constraint(equalToConstant: 220),
      button.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  @objc private func moveToSeacrh() {
    let vc = SearchCityViewController()
    vc.delegateFirstViewController = self
    self.present(vc, animated: true)
  }
}

extension FirstViewController: PushFromFisrtViewControllerDelegate {
  func pushFromSelf() {
    navigationController?.pushViewController(CitiesListViewController(), animated: true)
  }
}
