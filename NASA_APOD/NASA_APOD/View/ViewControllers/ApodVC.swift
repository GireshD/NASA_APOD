//
//  ViewController.swift
//  NASA_APOD
//
//  Created by Giresh Dora on 24/08/24.
//

import UIKit

class ApodVC: UIViewController {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    private let vm: ApodVCViewModel
    
    init?(vm: ApodVCViewModel, coder: NSCoder) {
        self.vm = vm
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(product:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIndicator.isHidden = true
        self.vm.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        vm.fetchApodData(dateStr: vm.getCurrentDate())
    }
    
    private func showLoading(){
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    
    private func hideLoading(){
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
    }

}

extension ApodVC: ApodVCViewModelProtocol{
    func didFetchedApodData(_ data: ApodVCModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            self.titleLbl.text = data.title
            self.descriptionLbl.text = data.imgDescription
            self.hideLoading()
        }
    }
    
    func didFinishedImageDownload(_ imgData: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.imgView.image = UIImage(data: imgData)
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            self.hideLoading()
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
}
