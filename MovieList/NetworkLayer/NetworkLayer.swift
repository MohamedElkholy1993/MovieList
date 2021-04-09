//
//  NetworkLayer.swift
//  MovieList
//
//  Created by moutaz hegazy on 3/11/21.
//  Copyright © 2021 Mohmaed_Elkholy. All rights reserved.
//

import Foundation
import UIKit
class NetworkLayer{
    static var sharedInstance = NetworkLayer()
    
    func getDataFromJSON(url:String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, respose, error) in
            completionHandler(data,respose,error)
        }
        
        task.resume()
    }
}
