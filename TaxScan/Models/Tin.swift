//
//  TinModel.swift
//  TaxScan
//
//  Created by Gadirli on 08.09.23.
//

import Foundation

struct Tin {
    let tin: String
    let company: String
    var isRisky: Bool
    var status: TinInformation?
    
    init(tin: String, company: String, isRisky: Bool, tinInformation: TinInformation?) {
        self.tin = tin
        self.company = company
        self.isRisky = isRisky
        self.status = tinInformation
    }
    
    init(dict: [String: Any]) {
       
        self.tin = dict["tin"] as? String ?? ""
        self.company = dict["company"] as? String ?? ""
        self.isRisky = false
        self.status = nil
    }
    
    
}
