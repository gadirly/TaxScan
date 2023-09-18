//
//  Constants.swift
//  TaxScan
//
//  Created by Gadirli on 10.09.23.
//

import Foundation
import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let TINS_REF = Database.database().reference().child("tins")
