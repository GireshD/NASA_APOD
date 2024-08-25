//
//  ImageLoaderService.swift
//  NeoSoft_Assignment
//
//  Created by Giresh Dora on 24/08/24.
//

import Foundation


class ImageLoaderService {
  private var loadedImages = [URL: Data]()
    
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<Data, Error>) -> Void) {
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let imgData = data {
                self.loadedImages[url] = imgData
                completion(.success(imgData))
                return
            }

        }
        task.resume()
    }
    
    
}
