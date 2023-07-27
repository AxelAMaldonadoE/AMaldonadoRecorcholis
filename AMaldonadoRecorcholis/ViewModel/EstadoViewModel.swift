//
//  EstadoViewModel.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 25/07/23.
//

import Foundation

class EstadoViewModel {
    
    private static let urlBase = "http://localhost/ProjectRecorcholis/"
    
    static func Add(_ nombre: String, idPais: Int, Response: @escaping(HTTPURLResponse?, Result?, Error?) -> Void) {
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
                    if 200...299 ~= responseSource.statusCode {
                        let jsonDecoder = JSONDecoder()
                        let root = try! jsonDecoder.decode(Root<Estado>.self, from: dataSource)
                        
                        result.Object = root
                        result.Correct = true
                    }
                }
                
                Response(responseSource, result, nil)
                print("Response Add Estado")
            }
            
            if let errorSource = error {
                Response(nil, nil, errorSource)
                print("Error Add Estado")
            }
        }.resume()
    }
    
    static func GetEstados(_ idPais: Int, Response: @escaping(HTTPURLResponse?, Result?, Error?) -> Void) {
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
                    if 200...299 ~= responseSource.statusCode {
                        let jsonDecoder = JSONDecoder()
                        let root = try! jsonDecoder.decode(Root<Estado>.self, from: dataSource)
                        
                        result.Object = root
                        result.Correct = true
                    }
                }
                
                Response(responseSource, result, nil)
                print("Response GetEstadosByPais")
            }
            
            if let errorSource = error {
                Response(nil, nil, errorSource)
                print("Error GetEstadosByPais")
            }
        }.resume()
    }
    
}
