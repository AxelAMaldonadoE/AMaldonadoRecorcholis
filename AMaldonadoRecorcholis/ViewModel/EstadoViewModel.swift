//
//  EstadoViewModel.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 25/07/23.
//

import Foundation

class EstadoViewModel {
    
    private static let urlBase = "http://localhost/ProjectRecorcholis/"
    
    static func Add(_ nombre: String, idPais: Int, Response: @escaping(Result?, Error?) -> Void) {
        var result = Result()
        let urlStr = "\(urlBase)addEstado.php"
        let url = URL(string: urlStr)!
        
        let param: [String: Any] = ["Nombre": nombre, "IdPais": idPais]
        let postData = try! JSONSerialization.data(withJSONObject: param)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseSource = response as? HTTPURLResponse {
                if let dataSource = data {
                    let decoder = JSONDecoder()
                    let root = try! decoder.decode(ServiceStatus.self, from: dataSource)
                    if 200...299 ~= responseSource.statusCode {
                        result.Correct = true
                    }
                    
                    result.Object = root
                }
                
                Response(result, nil)
                print("Response Add Estado")
            }
            
            if let errorSource = error {
                Response(nil, errorSource)
                print("Error Add Estado")
            }
        }.resume()
    }
    
    static func Update(_ idEstado: Int, _ nombre: String, Response: @escaping(Result?, Error?) -> Void) {
        let urlStr = "\(urlBase)updateEstado.php"
        let url = URL(string: urlStr)!
        
        var result = Result()
        
        let param: [String: Any] = ["IdEstado": idEstado, "Nombre": nombre]
        let postData = try! JSONSerialization.data(withJSONObject: param)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseSource = response as? HTTPURLResponse {
                if let dataSource = data {
                    let decoder = JSONDecoder()
                    let root = try! decoder.decode(ServiceStatus.self, from: dataSource)
                    
                    if 200...299 ~= responseSource.statusCode {
                        result.Correct = true
                    }
                    
                    result.Object = root
                }
                
                Response(result, nil)
                print("Response Add Estado")
            }
            
            if let errorSource = error {
                Response(nil, errorSource)
                print("Error Add Estado")
            }
        }.resume()
    }
    
    static func Delete(_ idEstado: Int, Response: @escaping(Result?, Error?) -> Void) {
        var result = Result()
        let urlStr = "\(urlBase)deleteEstado.php?idEstado=\(idEstado)"
        let url = URL(string: urlStr)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if let dataSource = data {
                    let decoder = JSONDecoder()
                    let root = try! decoder.decode(ServiceStatus.self, from: dataSource)
                    result.Object = root
                    
                    if 200...299 ~= httpResponse.statusCode {
                        result.Correct = true
                    }
                }
                
                Response(result, nil)
                print("response Delete Estado")
            }
            
            if let errorSource = error {
                Response(nil, errorSource)
                print("Error Delete Estado")
            }
        }.resume()
    }
    
    static func GetEstados(_ idPais: Int, Response: @escaping(Result?, Error?) -> Void) {
        var result = Result()
        let urlStr = "\(urlBase)getEstadosByPais.php"
        let url = URL(string: urlStr)!
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let param: [String: Any] = ["IdPais": idPais]
        let postData = try! JSONSerialization.data(withJSONObject: param)
        request.httpBody = postData as Data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseSource = response as? HTTPURLResponse {
                if let dataSource = data {
                    let jsonDecoder = JSONDecoder()
                    var root: Any? = nil
                    
                    if 200...299 ~= responseSource.statusCode {
                        root = try! jsonDecoder.decode(Root<Estado>.self, from: dataSource)
                        result.Correct = true
                    }
                    
                    if 400...499 ~= responseSource.statusCode {
                        root = try! jsonDecoder.decode(ServiceStatus.self, from: dataSource)
                    }
                    
                    result.Object = root
                }
                
                Response(result, nil)
                print("Response GetEstadosByPais")
            }
            
            if let errorSource = error {
                Response(nil, errorSource)
                print("Error GetEstadosByPais")
            }
        }.resume()
    }
    
}
