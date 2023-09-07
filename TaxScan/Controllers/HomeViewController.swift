//
//  HomeViewController.swift
//  TaxScan
//
//  Created by Gadirli on 06.09.23.
//

import UIKit

// MARK: - Properties

private let tinTableL: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
}()

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    

}
