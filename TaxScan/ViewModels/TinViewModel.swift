//
//  TinViewModel.swift
//  TaxScan
//
//  Created by Gadirli on 10.09.23.
//

import Foundation
import Firebase
import FirebaseAuth

enum TINError: Error {
    case notExist
    case notValid
    case databaseError
}

class TinVewModel {
    
    var tinList: [Tin] = [Tin]()
    var tinListWithStatuses: [Tin] = [Tin]()
    let currentUserId = Auth.auth().currentUser?.uid
    
    
    func fetchTins(completion: @escaping () -> ()) {
      
        guard let uid = currentUserId else {return}
        
        TinService.shared.getAllTinData(uid: uid) { [weak self] result in
            self?.tinList.removeAll()
            self?.tinList = result
            completion()
            
        }
        
    }
    
    
    func checkIsRisky(tin: String, completion: @escaping (Bool) -> ()) {
        APICaller.shared.getTinStatus(tin: tin) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                
                completion(false)
                
            }
        }
    }
    
    func loadData(completion: @escaping ([Tin]) -> ()) {
        tinListWithStatuses.removeAll()
        print("API called")
        fetchTins { [weak self] in
            
            guard let tinList = self?.tinList else { return}
            
            for tin in tinList {
                APICaller.shared.getTinStatus(tin: tin.tin) { result in
                    switch result {
                    case .success(let tinRiskResult):
                        self?.tinListWithStatuses.append(Tin(tin: tin.tin, company: tin.company, isRisky: true, tinInformation: tinRiskResult))
                    case .failure(_):
                        self?.tinListWithStatuses.append(Tin(tin: tin.tin, company: tin.company, isRisky: false, tinInformation: nil))
                       
                    }
                    
                    if self?.tinListWithStatuses.count == tinList.count {
                        if let list = self?.tinListWithStatuses {
                            completion(list)
                        }
                    }
                
                }
            }
        }
    }
    
    
    func addTin(text: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {return}
        
        APICaller.shared.checkTINValidity(tin: text) { exist, _ in
            guard let exist else {
                
                return
                
            }
            
            if exist {
                         
                APICaller.shared.getTaxpayerName(tin: text) { name in
                    
                    TinService.shared.setTinData(tin: text, company: name, uid: user.uid) { isAdded in
                            if isAdded {
                                
                                print("DEBUG: \(text) successfully added")
                                completion(.success(true))
                            }
                            else {
                                print("DEBUG: \(text) failed to add")
                                completion(.failure(TINError.databaseError))
                            }
                        }

                }
            }
            else {
                completion(.failure(TINError.notExist))
                print("\(text) TIN is not exist")
            }
        }
    }
    
    
    
    func deleteTin(tin: String, uid: String, completion: @escaping (Error?) -> Void) {
        TinService.shared.deleteTin(tin: tin, uid: uid, completion: completion)
    }
    
    
 
}
