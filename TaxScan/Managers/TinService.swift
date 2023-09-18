//
//  TinService.swift
//  TaxScan
//
//  Created by Gadirli on 10.09.23.
//

import Foundation
import Firebase

enum DBError: Error {
    case databaseError
}


class TinService {
    
    static let shared = TinService()
    
    func setTinData (tin: String, company: String, uid: String, completion: @escaping (Bool) -> ()) {
        
        let data: [String: Any] = ["tin": tin,
                                   "company": company]
        
        TINS_REF.child(uid).childByAutoId().setValue(data) { error, _ in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getAllTinData(uid: String, completion: @escaping ([Tin]) -> ()) {
        TINS_REF.child(uid).observe(.value) { (snapshot, _) in
            var tins = [Tin]()
            
            for childSnapshot in snapshot.children {
                if let tinData = (childSnapshot as? DataSnapshot)?.value as? [String: Any] {
                    let tin = Tin(dict: tinData)// Assuming you have a Tin model
                    tins.append(tin)
                }
            }
            
            completion(tins)
        }

    }
    
    func deleteTin(tin: String, uid: String, completion: @escaping (Error?) -> Void) {
        TINS_REF.child(uid).queryOrdered(byChild: "tin").queryEqual(toValue: tin).observeSingleEvent(of: .value) { (snapshot) in
            guard let firstChild = snapshot.children.allObjects.first as? DataSnapshot else {
                // Handle the case where the specified tin was not found
                let error = NSError(domain: "YourAppDomain", code: 404, userInfo: nil)
                completion(error)
                return
            }
            
            // Delete the first matching tin
            firstChild.ref.removeValue { (error, _) in
                completion(error)
            }
        }
    }

}
