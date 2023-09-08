//
//  HomeViewController.swift
//  TaxScan
//
//  Created by Gadirli on 06.09.23.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var models: [TinModel] = [TinModel(tin: "1223234323", companyName: "Deloitte & Touche"), TinModel(tin: "3443234543", companyName: "Azercell LLAC")]

    private let tinTable: UITableView = {
        let table = UITableView()
        table.register(TinTableViewCell.self, forCellReuseIdentifier: TinTableViewCell.identifier)
        return table
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        
    }
    
    // MARK: - Action
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "TIN",
                                      message: "Please enter TIN",
                                      preferredStyle: .alert)
        
        alert.addTextField()
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Add", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            guard let tin = Int(text) else {return}
//            self?.models.append(tin)
            self?.tinTable.reloadData()
            
        }))
        present(alert, animated: true)
    }
    
    @objc func logoutBtnClicked() {
        do {
            try Auth.auth().signOut()
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            }
        
        catch {
            print("DEBUG: Failed to logout.")
        }
    }
    
    // MARK: - Helpers
    
    private func configureUi() {
        view.backgroundColor = .systemBackground
        
        title = "TaxScan"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(logoutBtnClicked))
        
        view.addSubview(tinTable)
        tinTable.frame = view.frame
        tinTable.delegate = self
        tinTable.dataSource = self
        
        
    }
    

}

// MARK: - Extensions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tinTable.dequeueReusableCell(withIdentifier: TinTableViewCell.identifier, for: indexPath) as? TinTableViewCell else {return UITableViewCell()}
        var model = models[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
