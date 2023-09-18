//
//  TaxesApiManager.swift
//  TaxScan
//
//  Created by Miri Hasanov on 09.09.23.
//

import Foundation

enum APIError: Error {
    case failedToPrepareRequest
    case failedAPICall
}

class APICaller {
    static let shared = APICaller()
    
    let riskUrl = "https://www.e-taxes.gov.az/controllerrest"
    
    func getTinStatus(tin: String, completion: @escaping (Result<TinInformation, Error>) -> ()) {
        guard let url = URL(string: riskUrl) else {
            return
        }
        
        let requestBody: [String: Any] = ["voen": tin,
                                          "URL": "http://integdvx.vn.local/public/v1/api/integ/etaxesgovaz/riskliVoenInfo"]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(APIError.failedToPrepareRequest))
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("DEBUG: Failed to get data from etaxes: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.failedAPICall))
                return
            }
            
            do {
                
                
                let result = try JSONDecoder().decode([TinInformation].self, from: data)
                
                if let result = result.first {
                    completion(.success(result))
                }
                else {
                    
                    completion(.failure(APIError.failedAPICall))
                }
            }
            catch {
                print("DEBUG: Error while handling json: \(error)")
                completion(.failure(APIError.failedAPICall))
            }
        }
        
        // Start the data task
        task.resume()
        
    }
    

    

    func checkTINValidity(tin: String, completion: @escaping (Bool?, String?) -> Void) {
        // Define the API endpoint URL
        let urlString = riskUrl
        
        // Create the request URL
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL")
            return
        }
        
        // Create the request body as a JSON dictionary
        let requestBody: [String: Any] = ["voen": tin, "URL": "http://integdvx.vn.local/public/v1/api/integ/etaxesgovaz/riskliVoenInfo"]
        
        // Serialize the request body to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(nil, "Failed to serialize JSON")
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create a URLSession
        let session = URLSession.shared
        
        // Create a data task to send the request
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                
                // Parse the JSON response
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let errorMessage = json?["detail"] as? String{
                        completion(false, errorMessage)
                    } else {
                        // TIN is correct
                        completion(true, nil)
                    }
                } catch {
                    completion(nil, "Failed to parse JSON")
                }
            } else {
                completion(nil, "No data received")
            }
        }
        
        // Start the data task
        task.resume()
    }
    
    func getTaxpayerName(tin: String, completion: @escaping (String) -> ()) {
        guard let url = URL(string: "https://www.e-taxes.gov.az/controllerrest") else {
            return
        }
        
        let requestBody: [String: Any] = ["voen": tin,
                                          "URL": "http://integdvx.vn.local/public/v1/api/integ/etaxesgovaz/getTaxpayerHistoryByVoen"]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("DEBUG: Failed to serialize json for taxpayer name")
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                
                print("DEBUG: Failed to get data from etaxes: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                
                
                let fullNames = response.taxpayers.map { $0.fullName }
                
                
                completion(fullNames[0])
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        
        // Start the data task
        task.resume()
    }

    


    
}
