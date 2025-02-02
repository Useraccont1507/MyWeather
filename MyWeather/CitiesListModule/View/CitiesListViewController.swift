//
//  CitiesListViewController.swift
//  MyWeather
//
//  Created by Illia Verezei on 18.11.2024.
//

import UIKit

class CitiesListViewController: UIViewController {
  
  var presenter: CitiesListPresenterProtocol?
  
  let tableView = UITableView()
  let toolBar = UIToolbar()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.subscribeOnNotification()
    setupViewController()
    setupTableView(tableView)
    setupToolBar(toolBar)
  }
  
  private func setupViewController() {
    view.backgroundColor = .systemBackground
    self.title = "favorites".localized
    navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    navigationItem.hidesBackButton = true
    let editButton = UIBarButtonItem(title: "edit".localized, style: .plain, target: self, action: #selector(showEditing))
    editButton.tintColor = .colorForTextTheme
    navigationItem.rightBarButtonItem = editButton
  }
  
  private func setupToolBar(_ bar: UIToolbar) {
    bar.barTintColor = .systemBackground
    bar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bar)
    
    NSLayoutConstraint.activate([
      bar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      bar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    let toogleUnitsButton = UIBarButtonItem(title: "C° / F°", style: .plain, target: self, action: #selector(toogleUnits))
    toogleUnitsButton.tintColor = UIColor(named: "colorForTextTheme")
    let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
    let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(moveToSearchVC))
    addButton.tintColor = .colorForTextTheme
    
    bar.items = [toogleUnitsButton, spacer, addButton]
  }
  
  private func setupTableView(_ tableView: UITableView) {
    tableView.contentInsetAdjustmentBehavior = .automatic
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CitiesListTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.separatorStyle = .none
    tableView.allowsSelectionDuringEditing = false
    tableView.showsVerticalScrollIndicator = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  @objc private func showEditing() {
    presenter?.showEditing()
  }
  
  @objc private func toogleUnits(sender: UIBarItem) {
    presenter?.toogleUnits()
  }
  
  @objc private func moveToSearchVC() {
    presenter?.moveToSearchView(from: self)
  }
}

extension CitiesListViewController: CitiesListViewProtocol {
  func setPresenter(presenter: CitiesListPresenter) {
    self.presenter = presenter
  }
  
  func handleNetworkChange(isConnected: Bool) {
    if isConnected {
      self.tableView.reloadData()
      self.toolBar.items?.first?.isEnabled = true
    } else {
      self.toolBar.items?.first?.isEnabled = false
    }
  }
  
  func showingEditingMode() {
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
  
  func reloadingTableView() {
    self.tableView.reloadData()
  }
  
  func reloadingTableViewWithAnimation() {
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
  
  func deleteRowAt(index: Int) {
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
  }
}

extension CitiesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter?.showNumberOfCitites() ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CitiesListTableViewCell else { fatalError("Expected CitiesListTableViewCell") }
    cell.selectionStyle = .none
    cell.layoutIfNeeded()
    
    presenter?.fetchDataFor(index: indexPath.row, backgroundFrame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 110)) { forecast in
      DispatchQueue.main.async {
        if let updatedCell = tableView.cellForRow(at: indexPath) as? CitiesListTableViewCell {
          updatedCell.configure(forecast: forecast, indexPath: indexPath, tableView: tableView)
        }
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
    presenter?.goToCityControl(pageToShow: indexPath.row)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    presenter?.deleteCity(index: indexPath.row)
  }
}
