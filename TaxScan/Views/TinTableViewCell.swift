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
  
    private var tinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tinLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(playButton)
        
    
    
       
        
        configureUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
   
    
    // MARK: Helpers
    
    private func configureUi() {
        
        
        tinLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        companyLabel.anchor(top: tinLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 35)
        
        playButton.anchor(right: contentView.rightAnchor, paddingRight: 20)
        playButton.centerY(inView: contentView)
        
    }
    
    public func configure(with model: Tin, color: UIColor, label: UIColor) {
        tinLabel.text = model.tin
        companyLabel.text = model.company
        tinLabel.textColor = label
        companyLabel.textColor = label
        playButton.tintColor = label
        contentView.backgroundColor = color
    }
    
    
}
