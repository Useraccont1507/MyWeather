//
//  CitiesListViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class CitiesListViewController: UIViewController {
  
  var cities: [CityCoordinates] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    CitiesCoordinatesModel.shared.loadCitiesCoordinatesFromStorage()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    cities = CitiesCoordinatesModel.shared.getAllCitiesCoordinates()
  }
}
