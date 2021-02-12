//
//  APIClient.swift
//
//  Created by 城野 on 2021/02/12.
//  Copyright © 2021 Hibiki Jono. All rights reserved.
//

import Foundation

enum NetWorkError: Error, CustomStringConvertible {
    case unknown
    case invalidResponse
    case invalidURL
    
    var description: String {
        switch self {
        case .unknown: return "不明なエラー"
        case .invalidURL: return "不正なレスポンス"
        case .invalidResponse: return "不正なURL"
        }
    }
}

class APIClient {
    
    func sendRequest(success: @escaping ([String: Any]) -> (),
                      failure: @escaping (Error) -> ()) {
        
        guard  let requestURL = URL(string: "https://www.example.jp") else {
            failure(NetWorkError.invalidURL)
            return
        }
        
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if (error != nil) {
                failure(error!)
                return
            }
            
            guard let data = data else {
                failure(NetWorkError.unknown)
                return
            }
            
            guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []),
                  let json = jsonOptional as? [String: Any]
            else {
                failure(NetWorkError.invalidResponse)
                return
            }
            
            success(json)
        }
        task.resume()
    }
}
