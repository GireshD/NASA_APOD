//
//  ApodService.swift
//  NASA_APOD
//
//  Created by Giresh Dora on 24/08/24.
//

import Foundation

let API_KEY = "" //Generate  API key  from here https://api.nasa.gov and use it

protocol ApodServiceProtocol{
    func getApodData(date: String,
                     handler: @escaping ((Result<ApodModel, NetworkingError>) -> Void))
}

class ApodService: ApodServiceProtocol{
    
    
    func getApodData(date: String,
                     handler: @escaping ((Result<ApodModel, NetworkingError>) -> Void)) {
        
        let url = self.buildQuery(date: date)
        guard url != nil else {
            debugPrint("Can't build query: bad params")
            handler(.failure(.badParams))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url!) { (json, response, error) in
            
            if let error = error as? NSError{
                if error.code == -1009{
                    handler(.failure(.noInternet))
                }
                else {
                    handler(.failure(.noData))
                }
                return
            }
            
            // Check the response from the server (200 == OK)
            let httpResponse = response as! HTTPURLResponse
            guard httpResponse.statusCode == 200 else {
                handler(.failure(.badResponse))
                return
            }
            
            // JSONEncoder and JSONDecoder allow you to easily encode/decode Codable structs/classes
            let decoder = JSONDecoder()
            
            let apodData = try? decoder.decode(ApodModel.self, from: json!)
            guard let apodData = apodData else {
                handler(.failure(.cantDecode))
                return
            }
            
            handler(.success(apodData))
        }
        
        task.resume()
    }
    
    
    
    private func buildQuery(date: String) -> URL? {
        // Build the request URL
        
        var request = URLComponents()
        request.scheme = "https"
        request.host = "api.nasa.gov"
        request.path = "/planetary/apod"
        request.queryItems = [URLQueryItem(name: "api_key", value: API_KEY)]
        
        request.queryItems?.append(URLQueryItem(name: "date", value: date))
        
        return request.url
    }
}


enum NetworkingError: Error {
    case noError        // No current error
    case badParams      // Can't make a valid URL using the supplied parameters
    case badResponse    // Server returned an error
    case noData         // No data returned by APOD API
    case cantDecode     // Unable to decode the JSON returned by APOD API
    case noInternet
    
    func description() -> String {
        switch self {
        case .noError:      return "No Error"
        case .badParams:    return "Can't make a valid URL using the supplied parameters"
        case .badResponse:  return "Server returned an error"
        case .noData:       return "No data returned by APOD API"
        case .cantDecode:   return "Not Decodable (JSON couldn't be parsed)"
        case .noInternet:   return "We are not connected to the internet, showing you the last image we have"
        }
    }
}
