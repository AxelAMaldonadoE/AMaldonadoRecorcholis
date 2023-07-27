//
//  PaisViewModel.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 25/07/23.
//

import Foundation

class PaisViewModel {
    
    private static let baseUrl = "http://localhost/ProjectRecorcholis/"
    
    static func Add(_ nombre: String, Response: @escaping(HTTPURLResponse?, Result?, Error?) -> Void) {
        var result = Result()
        let urlStr = "\(baseUrl)addPais.php"
        let url = URL(string: urlStr)!
        
        let param: [String: Any] = ["Nombre": nombre]
        let postData = try! JSONSerialization.data(withJSONObject: param)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if let dataSource = data {
                    let decoder = JSONDecoder()
                    if 200...299 ~= httpResponse.statusCode {
                        let root = try! decoder.decode(Root<Pais>.self, from: dataSource)
                        
                        result.Object = root
                        result.Correct = true
                    }
                }
                
                Response(httpResponse, result, nil)
                print("Response Add Pais")
            }
            
            if let errorSource = error {
                Response(nil, nil, errorSource)
                print("Error Add Pais")
            }
        }.resume()
        
    }
    
    static func Update(_ nombre: String, _ id: Int, Response: @escaping(HTTPURLResponse?, Result?, Error?) -> Void) {
        var result = Result()
        let urlStr = "\(baseUrl)updatePais.php"
        let url = URL(string: urlStr)!
        
        let param: [String: Any] = ["Nombre": nombre, "IdPais": id]
        
        let postData = try! JSONSerialization.data(withJSONObject: param)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if let dataSource = data {
                    let decoder = JSONDecoder()
                    if 200...299 ~= httpResponse.statusCode {
                        let root = try! decoder.decode(Root<Pais>.self, from: dataSource)
                        
                        result.Object = root
                        result.Correct = true
                    }
                }
                
                Response(httpResponse, result, nil)
                print("Response Add Pais")
            }
            
            if let errorSource = error {
                Response(nil, nil, errorSource)
                print("Error Add Pais")
            }
        }.resume()
        
    }
    
    static func Delete(_ id: Int, Response: @escaping(HTTPURLResponse?, Result?, Error?) -> Void) {
        var result = Result()
        let urlStr = "\(baseUrl)deletePais.php?idPais=\(id)"
        let url = URL(string: urlStr)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if let dataSource = data {
                    if 200...299 ~= httpResponse.statusCode {
                        let decoder = JSONDecoder()
                        let root = try! decoder.decode(Root<Pais>.self, from: dataSource)
                        
                        result.Object = root
                        result.Correct = true
                    }
                }
                
                Response(httpResponse, result, nil)
                print("response Delete pais")
            }
            
            if let errorSource = error {
                Response(nil, nil, errorSource)
                print("Error Delete Pais")
            }
        }.resume()
    }
    
    static func GetAll(Response: @escaping(HTTPURLResponse?, Result?, Error?) -> Void) {
        var result = Result()
        let url = URL(string: "\(baseUrl)getPaises.php")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let responseSource = response as? HTTPURLResponse {
                if 200...299 ~= responseSource.statusCode {
                    if let dataSource = data {
                        let jsonDecoder = JSONDecoder()
                        let obj = try! jsonDecoder.decode(Root<Pais>.self, from: dataSource)
                        
                        result.Object = obj
                        result.Correct = true
                    }
                }
                
                Response(responseSource, result, nil)
                print("Response Get All Paises")
            }
            
            if let errorSource = error {
                Response(nil, nil, errorSource)
                print("Error Get All Paises")
            }
        }.resume()
        
    }
    
    static func SearchByNombre(_ nombre: String, Response: @escaping(HTTPURLResponse?, Result?, Error?) -> Void) {
        let urlStr = "\(baseUrl)openSearch.php?keyword=\(nombre)"
        let url = URL(string: urlStr)!
        var result = Result()
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let responseSource = response as? HTTPURLResponse {
                if 200...299 ~= responseSource.statusCode {
                    if let dataSource = data {
                        let jsonDecoder = JSONDecoder()
                        let obj = try! jsonDecoder.decode(RootSearch.self, from: dataSource)
                        
                        result.Object = obj
                        result.Correct = true
                    }
                }
                
                Response(responseSource, result, nil)
                print("Response SearchByNombre")
            }
            
            if let errorSource = error {
                Response(nil, nil, errorSource)
                print("Error SearchByNombre")
            }
        }.resume()
    }
}
