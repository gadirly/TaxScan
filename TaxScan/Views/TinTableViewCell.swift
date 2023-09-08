//
//  TinTableViewCell.swift
//  TaxScan
//
//  Created by Gadirli on 08.09.23.
//

import UIKit

class TinTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TinTableViewCell"
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
       
        button.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private var tinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tinLabel)
        contentView.addSubview(companyLabel)
        
        configureUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    // MARK: Helpers
    
    private func configureUi() {
        tinLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        companyLabel.anchor(top: tinLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
    }
    
    public func configure(with model: TinModel) {
        tinLabel.text = model.tin
        companyLabel.text = model.companyName
    }
    
    
}
