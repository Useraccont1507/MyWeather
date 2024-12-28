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
  lazy private var toolBar = UIToolbar()
  lazy private var failConnectionMessageView = FailConnectionMessageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
    CitiesCoordinatesModel.shared.loadCitiesCoordinatesFromStorage(coordinates: Storage.shared.loadCityCoordinates())
    cities = CitiesCoordinatesModel.shared.getAllCitiesCoordinates()
    setupToolBar(toolBar)
    setupTableView(tableView)
    setupFailConnectionMessageView(failConnectionMessageView)
  }
  
  private func setupViewController() {
    view.backgroundColor = .systemBackground
    self.title = "favorites".localized
    self.navigationItem.hidesBackButton = true
    navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    let editButton = UIBarButtonItem(title: "edit".localized, style: .plain, target: self, action: #selector(showEditing))
    editButton.tintColor = .black
    navigationItem.rightBarButtonItem = editButton
  }
  
  private func setupToolBar(_ bar: UIToolbar) {
    bar.barTintColor = .white
    bar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bar)
    
    NSLayoutConstraint.activate([
      bar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    let toogleUnitsButton = UIBarButtonItem(title: "C° / F°", style: .plain, target: self, action: #selector(toogleUnits))
    toogleUnitsButton.tintColor = .black
    let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
    let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(moveToSearchVC))
    addButton.tintColor = .black
    
    bar.items = [toogleUnitsButton, spacer, addButton]
  }
  
  private func setupTableView(_ tableView: UITableView) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CitiesListTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.separatorStyle = .none
    tableView.isUserInteractionEnabled = NetworkMonitor.shared.isConnected
    
    NetworkMonitor.shared.onStatusChange = { [weak self] isConnected in
      self?.handleNetworkChange(isConnected: isConnected)
    }
    
    tableView.allowsSelectionDuringEditing = false
    tableView.showsVerticalScrollIndicator = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: toolBar.topAnchor)
    ])
  }
  
  private func setupFailConnectionMessageView(_ view: FailConnectionMessageView) {
    view.isHidden = true
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
      view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      view.heightAnchor.constraint(equalToConstant: 150)
    ])
  }
  
  @objc private func showEditing() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
      if self.tableView.isEditing == true {
        self.tableView.isEditing = false
        self.navigationItem.rightBarButtonItem?.title = "edit".localized
        self.navigationItem.rightBarButtonItem?.style = .plain
      } else {
        self.tableView.isEditing = true
        self.navigationItem.rightBarButtonItem?.title = "done".localized
        self.navigationItem.rightBarButtonItem?.style = .done
      }
    }
  }
  
  @objc private func toogleUnits(sender: UIBarItem) {
    switch WebManager.shared.getUnits() {
    case .imperial:
      WebManager.shared.switchToCelsiusUnits()
      self.reloadTableViewWithAnimation()
    case .metric:
      WebManager.shared.switchToFahrenheitUnits()
      self.reloadTableViewWithAnimation()
    }
  }
  
  @objc private func moveToSearchVC() {
    let vc = SearchCityViewController()
    vc.delegateFirstViewController = nil
    vc.delegateReloadCities = self
    self.present(vc, animated: true)
  }
  
  private func reloadTableViewWithAnimation() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
      self.navigationItem.rightBarButtonItem?.isEnabled = false
      self.toolBar.items?.first?.isEnabled = false
      self.toolBar.items?.last?.isEnabled = false
      self.tableView.transform = CGAffineTransform(translationX: -self.tableView.frame.width, y: 0)
    } completion: { isFinished in
      if isFinished {
        self.tableView.reloadData()
        self.tableView.transform = CGAffineTransform(translationX: self.tableView.frame.width, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut) {
          self.tableView.transform = .identity
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.toolBar.items?.first?.isEnabled = true
        self.toolBar.items?.last?.isEnabled = true
      }
    }
  }
  
  private func handleNetworkChange(isConnected: Bool) {
    tableView.isUserInteractionEnabled = isConnected
    if isConnected {
      tableView.reloadData()
    }
  }
}
  
  extension CitiesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CitiesListTableViewCell else { fatalError("Expected CitiesListTableViewCell") }
    
    cell.failConnectionDelegate = self
    cell.selectionStyle = .none
    cell.layoutIfNeeded()
    
    let coordinates = cities[indexPath.row]
    
    cell.configure(coordinates: coordinates) { isSuccesful in
      DispatchQueue.main.async {
        cell.isUserInteractionEnabled = isSuccesful
      }
    }
    return cell
  }
}

extension CitiesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    126
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    vc.transferCities(self.cities, pageIndex: indexPath.row)
    navigationController?.pushViewController(vc, animated: true)
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
    self.tableView.reloadSections(IndexSet(integer: 0), with: .middle)
  }
}

extension CitiesListViewController: PresentFailConnection {
  func present() {
    self.failConnectionMessageView.isHidden = false
  }
}
