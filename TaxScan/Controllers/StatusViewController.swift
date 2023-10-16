//
//  StatusViewController.swift
//  TaxScan
//
//  Created by Gadirli on 17.09.23.
//

import UIKit

enum Sections: Int {
    case tin = 0
    case company = 1
    case taxAuthority = 2
    case date = 3
    case decisionId = 4
    case madi = 5
}

class StatusViewController: UIViewController {
    // MARK: - Properties
    
    var tinInformation: TinInformation?
    
    let sectionTitles: [String] = [
        "VÖEN:",
        "Vergi ödəyicisinin adı:",
        "Vergi orqanı:",
        "Tarix:",
        "Qərarın nömrəsi:",
        "Qərar:"
        
    ]
    
    private let statusTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let statusImage: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 6
        return imageView
    }()
    
    private let statusLabel: UILabel = {
        var label = UILabel()
        label.text = "Bu vergi ödəyicisi riskli vergi ödəyiciləri siyahısındadır."
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        statusTableView.frame = view.bounds
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        title = "Status"
        view.backgroundColor = .white
        view.addSubview(statusTableView)
        statusTableView.delegate = self
        statusTableView.dataSource = self
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 170))
        statusTableView.tableHeaderView = headerView
        
        headerView.addSubview(statusImage)
        statusImage.center(inView: headerView)
        statusImage.anchor(width: 90, height: 90)
        
        headerView.addSubview(statusLabel)
        statusLabel.anchor(top: statusImage.bottomAnchor, paddingTop: 20)
        statusLabel.centerX(inView: headerView)
        
        DispatchQueue.main.async {
            self.statusTableView.reloadData()
        }
        
    }
    
    
    
    func configure(with model: TinInformation?) {
        
        if let model {
            statusImage.image = UIImage(systemName: "xmark.shield.fill")
            statusImage.tintColor = .systemRed
            tinInformation = model
        } else {
            
        }
    }
}

// MARK: - TableViewExtension

extension StatusViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .label
        var config = UIListContentConfiguration.cell()
        
        
        guard let tinInformation else { return UITableViewCell() }
        
        switch indexPath.section {
        case Sections.tin.rawValue:
            
            config.text = tinInformation.voen ?? ""
            
        case Sections.company.rawValue:
            config.text = tinInformation.name ?? ""
        case Sections.taxAuthority.rawValue:
            config.text = tinInformation.vorgan ?? ""
        case Sections.date.rawValue:
            config.text = tinInformation.qtarix ?? ""
        case Sections.decisionId.rawValue:
            config.text = tinInformation.qnomre ?? ""
        case Sections.madi.rawValue:
            config.text = tinInformation.madi
        default:
            return UITableViewCell()
        }
        
        
        cell.contentConfiguration = config
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 15, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
//        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
}
