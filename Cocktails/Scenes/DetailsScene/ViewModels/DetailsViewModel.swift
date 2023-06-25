//
//  DetailsViewModel.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailsViewModel {
    private let drinkID: String
    private let networkService: NetworkService
    private let disposeBag = DisposeBag()
    
    let drinkDetail: PublishSubject<DrinkDetail> = PublishSubject<DrinkDetail>()
    let drinkImage: PublishSubject<UIImage> = PublishSubject<UIImage>()

    init(drinkID: String, networkService: NetworkService = NetworkService.shared) {
        self.drinkID = drinkID
        self.networkService = networkService
        fetchDrinkDetails()
    }
    
    private func fetchDrinkDetails() {
        networkService.fetchDrinkDetail(by: drinkID)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] drinkDetail in
                self?.drinkDetail.onNext(drinkDetail)
                self?.fetchImage(from: drinkDetail.strDrinkThumb)
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    private func fetchImage(from url: String) {
        let resource = KF.ImageResource(downloadURL: URL(string: url)!)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { [weak self] result in
            switch result {
            case .success(let imageResult):
                self?.drinkImage.onNext(imageResult.image)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
