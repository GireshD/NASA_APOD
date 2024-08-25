//
//  ApodViewModel.swift
//  NASA_APOD
//
//  Created by Giresh Dora on 24/08/24.
//

import Foundation

protocol ApodVCViewModelProtocol: AnyObject{
    func didFetchedApodData(_ data: ApodVCModel)
    func didFinishedImageDownload(_ imgData: Data)
    func showError(_ message: String)
}

class ApodVCViewModel{
    
    private let serivce: ApodServiceProtocol
    private let imageLoader: ImageLoaderService
    
    weak var delegate: ApodVCViewModelProtocol?
    
    init(serivce: ApodServiceProtocol, imageLoader: ImageLoaderService) {
        self.serivce = serivce
        self.imageLoader = imageLoader
    }
    
    func fetchApodData(dateStr: String){
        serivce.getApodData(date: dateStr) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let apodModel):
                let model = apodModel.getApodVCModel()
                self.fetchImage(imgString: apodModel.url ?? "")
                self.delegate?.didFetchedApodData(model)
            case .failure(let failure):
                self.delegate?.showError(failure.description())
            }
        }
    }
    
    
    func getCurrentDate() -> String {
        var dateStr = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateStr = dateFormatter.string(from: Date())
        return dateStr
    }
    
    func fetchImage(imgString: String){
        guard let url = URL(string: imgString) else {return}
        
        imageLoader.loadImage(url) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let imgDate):
                self.delegate?.didFinishedImageDownload(imgDate)
            case .failure(_):
                debugPrint("failed image download")
            }
        }
    }
    
    
}
