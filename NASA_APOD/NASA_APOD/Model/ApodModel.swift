//
//  ApodModel.swift
//  NASA_APOD
//
//  Created by Giresh Dora on 24/08/24.
//

import Foundation

struct ApodModel: Codable {
    let date: String?
    let explanation: String?
    let title: String?
    let url: String?
    
    func getApodVCModel() -> ApodVCModel{
        return ApodVCModel(title: self.title ?? "",
                                  imgDescription: self.explanation ?? "")
    }
}
