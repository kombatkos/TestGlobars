//
//  MenuViewController.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 11.10.2020.
//

import UIKit

protocol MenuViewControllerDelegate {
    func showMenu(carsData: ListCars?)
    func hideMenu(index: Int?)
}

class MenuViewController: UIViewController {
    
    var delegate: MenuViewControllerDelegate?
//    var containerDelegate: MapViewControllerDelegate?
    var index = 0
    
    @IBOutlet weak var tableView: UITableView!
    var carsData: ListCars?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: MenuTableCell.reuseId)
//        view.addSubview(tableView)
//        tableView.frame = view.frame
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        tableView.backgroundColor = .darkGray
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableCell.reuseId) as! MenuTableCell
//        let menuModel = Menu(rawValue: indexPath.row)
        let car = carsData?.data[indexPath.row]
        cell.iconImageView.image = UIImage(named: car?.name ?? "")
        cell.myLabel.text = car?.name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.hideMenu(index: indexPath.row)
    }
}
