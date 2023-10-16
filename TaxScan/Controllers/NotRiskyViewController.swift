//
//  NotRiskyViewController.swift
//  TaxScan
//
//  Created by Babek Gadirli on 16.10.23.
//

import UIKit

class NotRiskyViewController: UIViewController {
    
    // MARK: Properties
    
    private let statusImage: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 6
        imageView.image = UIImage(systemName: "checkmark.shield.fill")
        return imageView
    }()
    
    private let statusLabel: UILabel = {
        var label = UILabel()
        label.text = "Bu vergi ödəyicisi riskli vergi ödəyiciləri siyahısında yoxdur."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
         configureUI()
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        
        view.addSubview(statusImage)
        view.addSubview(statusLabel)
        
        statusImage.anchor(top: view.topAnchor, paddingTop: 300, width: 90, height: 90)
        statusImage.centerX(inView: view)
        
        
        statusLabel.anchor(top: statusImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20 )
        
    }
    
    
    

}
