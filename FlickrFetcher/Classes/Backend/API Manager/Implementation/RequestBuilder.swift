//
//  RequestBuilder.swift
//  FlickrFetcher
//
//  Created by Bartosz Olszanowski on 12/10/2016.
//  Copyright © 2016 Bartosz Olszanowski. All rights reserved.
//

import Foundation

final class RequestBuilder: RequestBuilderType {
    
    // MARK: Requests
    
    func GETRequest(withURL url: URL, completion: @escaping ResultBlock<[String: Any]>) {
        let conf = configuration(forURL: url, httpMethod: "GET")
        
        conf.session.dataTask(with: conf.request) { (data, response, error) in
            
            if let error = error {
                completion(Result.Error(error: error))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                //completion(Result.Error(error: Error())) error handling wrong status code
                return
            }
            
            guard
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let photo = (jsonResponse?["photos"] as? [String: Any])?["photo"] as? [String: Any]
            else {
                // Error
                return
            }
            
            completion(Result.Success(result: photo))
            
        }.resume()
    }
    
    func GETRequest(withURL url: URL, completion: @escaping ArrayResultBlock<[String: Any]>) {
        let conf = configuration(forURL: url, httpMethod: "GET")
        
        conf.session.dataTask(with: conf.request) { (data, response, error) in
            
            if let error = error {
                completion(ArrayResult.Error(error: error))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                //completion(Result.Error(error: Error())) error handling wrong status code
                return
            }
            
            guard
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let photos = (jsonResponse?["photos"] as? [String: Any])?["photo"] as? [[String: Any]]
                else {
                    // Error
                    return
            }
            
            completion(ArrayResult.Success(result: photos))
            
            }.resume()
    }
    
//    func POSTRequest(withURL url: URL, parameters: Dictionary<String, Any>? = nil, completion: @escaping ResultBlock<[String: Any]>) {
//        let conf = configuration(forURL: url, parameters: parameters, httpMethod: "POST")
//        
//        conf.session.dataTask(with: conf.request) { (data, response, error) in
//            
//            if let error = error {
//                completion(Result.Error(error: error))
//                return
//            }
//            
//            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                //completion(Result.Error(error: Error())) error handling
//                return
//            }
//            
//            let jsonResponse = JSON(data: data)
//            completion(Result.Success(result: jsonResponse))
//            
//        }.resume()
//    }
//    
//    func POSTRequest(withURL url: URL, parameters: Dictionary<String, Any>? = nil, completion: @escaping ArrayResultBlock<[String: Any]>) {
//        let conf = configuration(forURL: url, parameters: parameters, httpMethod: "POST")
//        
//        conf.session.dataTask(with: conf.request) { (data, response, error) in
//            
//            if let error = error {
//                completion(ArrayResult.Error(error: error))
//                return
//            }
//            
//            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                //completion(ArrayResult.Error(error: Error())) error handling
//                return
//            }
//            
//            let jsonResponse = JSON(data: data)
//            if let jsonResponseArray = jsonResponse.array {
//                completion(ArrayResult.Success(result: jsonResponseArray))
//            } else {
//                //completion(ArrayResult.Error(error: Error())) error cannot convert to array
//            }
//            
//            }.resume()
//    }
    
    fileprivate func configuration(forURL url: URL, parameters: Dictionary<String, String>? = nil, httpMethod: String)  -> (request: URLRequest, session: URLSession) {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = httpMethod
        if let parameters = parameters {
            let paramData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = paramData
        }
        
        return (request, session)
    }
}
