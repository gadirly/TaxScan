//
//  HomeViewController.swift
//  TaxScan
//
//  Created by Gadirli on 06.09.23.
//

import UIKit
import Firebase
import FirebaseAuth


class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var isFilterButtonSelected = false
    
    private var viewModel = TinVewModel()
    var filteredTinList: [Tin] = []
    var myTinList: [Tin] = []

    private let tinTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        
        table.backgroundColor = UIColor.clear
        table.register(TinTableViewCell.self, forCellReuseIdentifier: TinTableViewCell.identifier)
        return table
    }()
    
    private lazy var addNewButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitle("+ Yeni", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        updateUi()
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tinTable.backgroundColor = UIColor.clear
        tinTable.frame = view.bounds
        
    }
    
    
    
    // MARK: - Action
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "VÖEN",
                                      message: "VÖEN Daxil edin",
                                      preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Əlavə et", style: .default, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.viewModel.addTin(text: text) {isAdded in
                switch isAdded {
                case .success(_):
                    self?.updateUi()
                case .failure(_):
                    print("Failure")
                    let dialogMessage = UIAlertController(title: "Xəta", message: "Belə VÖEN mövcud deyil və ya ƏDV qeydiyyatında olmadığından, bu VÖEN-lə əməliyyat etməyə hüququnuz yoxdur.", preferredStyle: .alert)

                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        
                      })

                    dialogMessage.addAction(ok)
                    DispatchQueue.main.async {
                        self?.present(dialogMessage, animated: true, completion: nil)
                    }
                    
                }
            }
         
        }))
        
        alert.addAction(UIAlertAction(title: "Ləğv et", style: .cancel, handler: nil))
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
    
    @objc func filterTinClicked() {
        
        filteredTinList.removeAll()
        
        if isFilterButtonSelected {

            isFilterButtonSelected = false
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "line.3.horizontal.decrease.circle")

            

            tinTable.reloadData()

            } else {
                isFilterButtonSelected = true

                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")

                filteredTinList = myTinList.filter { $0.isRisky }

                tinTable.reloadData()
            }
            
       
    }
    


    
    // MARK: - Helpers
    
    private func configureUi() {
        
        
        title = "Əsas"
        view.backgroundColor = .systemBackground
       
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Axtar"
        navigationItem.titleView = searchBar
//        searchBar.scopeButtonTitles = ["All", "Risky"]
//        searchBar.showsScopeBar = true
        
        
        
        // Configure header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 35))
        headerView.addSubview(addNewButton)
        addNewButton.anchor(bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingRight: 20)
        tinTable.tableHeaderView = headerView
        view.addSubview(tinTable)
        
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .done, target: self, action: #selector(filterTinClicked))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(logoutBtnClicked))
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        tinTable.separatorStyle = .none
  
        
        tinTable.delegate = self
        tinTable.dataSource = self
        
        
    }
    
    private func updateUi() {
        
        filteredTinList.removeAll()
        
        viewModel.loadData { [weak self] list in
            self?.myTinList = list
            DispatchQueue.main.async {
                self?.tinTable.reloadData()
            }

            }    
    }

}

// MARK: - Extensions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return filteredTinList.isEmpty ? myTinList.count : filteredTinList.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.layer.masksToBounds = true
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tinTable.dequeueReusableCell(withIdentifier: TinTableViewCell.identifier, for: indexPath) as? TinTableViewCell else {return UITableViewCell()}
        let model = filteredTinList.isEmpty ? myTinList[indexPath.row] : filteredTinList[indexPath.row]
        
          
        
        if model.isRisky {
             cell.configure(with: model, color: .systemRed, label: .white)
           
            } else {
                cell.configure(with: model, color: .systemBackground, label: .black)
            }
        
        
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if filteredTinList.isEmpty {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        
        
        guard let user = Auth.auth().currentUser?.uid else {
            return
        }

        let tin = myTinList[indexPath.row]
        tableView.beginUpdates()
        myTinList.remove(at: indexPath.row)
        filteredTinList.removeAll()
        tableView.deleteRows(at: [indexPath], with: .fade)

        
        viewModel.deleteTin(tin: tin.tin, uid: user) { error in
            if let error {
                print("DEBUG: Error while deleting tin: \(error)")
            }else {
                print("DEBUG: TIN Successfully deleted.")
            }
        }
        
        tableView.endUpdates()
        
        print(myTinList)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StatusViewController()
        let myTin = myTinList[indexPath.row]
        guard let tinStatus = myTin.status else {
            let vcRisky = NotRiskyViewController()
            present(vcRisky, animated: true)
            return
        }
        vc.configure(with: tinStatus)
        present(vc, animated: true)
    }

    
    
}

// MARK: - Searchbar extension

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {



        filteredTinList = viewModel.tinListWithStatuses.filter { tin in
                return tin.tin.lowercased().contains(searchText.lowercased()) || tin.company.lowercased().contains(searchText.lowercased())
            }
            tinTable.reloadData()

    }


}
