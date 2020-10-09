//
//  Networking.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 09.10.2020.
//

import Foundation

class Networking {
    
    weak var delegate: URLStringDelegate?
    
    // POST Method
    func postMethod(urlString: String, userName: String, password: String,
                    completion: @escaping (_ data: Data) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        let parameters = ["username": userName, "password": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ru", forHTTPHeaderField: "Accept-Language")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        fetchData(request: request, completion: completion)
    }
    
    // GET Method
    func getMethod(urlString: String, token: String?, completion: @escaping (_ data: Data) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        guard let token = token else { return }
        
        var request  = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchData(request: request, completion: completion)
    }
    
    // Fetch Data
    func fetchData(request: URLRequest?, completion: @escaping (_ data: Data) -> ()) {
        guard let request = request else { return }
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print(response ?? "no response")
            }
            guard let data = data else { return }
            completion(data)
        }.resume()
        
    }
    
}
