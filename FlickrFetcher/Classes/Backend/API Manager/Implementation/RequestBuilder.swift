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
    
    func GETRequest(withURL url: URL, completion: @escaping PaginationResultBlock<[String: Any]>) {
        let (request, session) = configuration(forURL: url, httpMethod: "GET")
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(Result.error(error), nil)
                return
            }
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(Result.error(APIError.noData), nil)
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(Result.error(APIError.wrongHttpCode(code: httpResponse.statusCode)), nil)
                return
            }
            
            guard
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let photos = jsonResponse?["photos"] as? [String: Any],
                let photo = photos["photo"] as? [String: Any]
            else {
                completion(Result.error(APIError.jsonSerializationFailed), nil)
                return
            }
            guard
                let page = photos["page"] as? Int,
                let pages = photos["pages"] as? Int,
                let perPage = photos["perpage"] as? Int
            else {
                completion(Result.success(photo), nil)
                return
            }
            let pagination = APIPagination(page: page, pages: pages, perPage: perPage)
            completion(Result.success(photo), pagination)
            
        }.resume()
    }
    
    func GETRequest(withURL url: URL, completion: @escaping PaginationResultBlock<[[String: Any]]>) {
        let (request, session) = configuration(forURL: url, httpMethod: "GET")
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(Result.error(error), nil)
                return
            }
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(Result.error(APIError.noData), nil)
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(Result.error(APIError.wrongHttpCode(code: httpResponse.statusCode)), nil)
                return
            }
            
            guard
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let photos = jsonResponse?["photos"] as? [String: Any],
                let photo = photos["photo"] as? [[String: Any]]
                else {
                    completion(Result.error(APIError.jsonSerializationFailed), nil)
                    return
            }
            guard
                let page = photos["page"] as? Int,
                let pages = photos["pages"] as? Int,
                let perPage = photos["perpage"] as? Int
            else {
                completion(Result.success(photo), nil)
                return
            }
            let pagination = APIPagination(page: page, pages: pages, perPage: perPage)
            completion(Result.success(photo), pagination)
            
            }.resume()
    }
    
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
