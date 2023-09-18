//
//  TaxPayerModel.swift
//  TaxScan
//
//  Created by Gadirli on 10.09.23.
//

import Foundation

struct Response: Decodable {
    let taxpayers: [Taxpayer]
}

struct Taxpayer: Decodable {
    let fullName: String
    let opDate: String
    let opType: String
}
