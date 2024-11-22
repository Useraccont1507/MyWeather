//
//  CitiesListViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class CitiesListViewController: UIViewController {
  
  private var cities: [CityCoordinates] = []
  
  lazy private var tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
    CitiesCoordinatesModel.shared.loadCitiesCoordinatesFromStorage(coordinates: Storage.shared.loadCityCoordinates())
    cities = CitiesCoordinatesModel.shared.getAllCitiesCoordinates()
    setupTebleView(tableView)
  }
  
  private func setupViewController() {
    view.backgroundColor = .systemBackground
    self.title = "favorites".localized
    self.navigationItem.hidesBackButton = true
    navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "edit".localized, style: .plain, target: self, action: #selector(showEditing))
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(moveToSearchVC))
  }
  
  private func setupTebleView(_ tableView: UITableView) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CitiesListTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc private func showEditing() {
    if self.tableView.isEditing == true {
      self.tableView.isEditing = false
      self.navigationItem.leftBarButtonItem?.title = "edit".localized
      self.navigationItem.leftBarButtonItem?.style = .plain
    } else {
      self.tableView.isEditing = true
      self.navigationItem.leftBarButtonItem?.title = "done".localized
      self.navigationItem.leftBarButtonItem?.style = .done
    }
  }
  
  @objc private func moveToSearchVC() {
    let vc = SearchViewController()
    vc.delegateFirstViewController = nil
    vc.delegateReloadCities = self
    self.present(vc, animated: true)
  }
}

extension CitiesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CitiesListTableViewCell else { fatalError("Expected CitiesListTableViewCell") }
    cell.configure(coordinates: cities[indexPath.row])
    return cell
  }
}

extension CitiesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    126
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    cities.remove(at: indexPath.row)
    CitiesCoordinatesModel.shared.deleteCityCoordinates(indexPath.row)
    Storage.shared.saveCityCoordinates(CitiesCoordinatesModel.shared.getAllCitiesCoordinates())
    tableView.deleteRows(at: [indexPath], with: .left)
  }
}

extension CitiesListViewController: ReloadCitiesTableViewControllerDelegate {
  func reload() {
    self.cities = CitiesCoordinatesModel.shared.getAllCitiesCoordinates()
    self.tableView.reloadData()
  }
}
