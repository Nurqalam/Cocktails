//
//  NetworkService.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import Alamofire
import RxSwift
import RxCocoa
import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func fetchDrinks(for category: String) -> Observable<DrinksResponse> {
        return Observable.create { observer in
            let parameters = ["a": category]
            let request = AF.request(Constants.urlString, parameters: parameters)
                .validate()
                .responseDecodable(of: DrinksResponse.self) { response in
                    switch response.result {
                    case .success(let drinksResponse):
                        observer.onNext(drinksResponse)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func fetchDrinkDetail(by id: String) -> Observable<DrinkDetail> {
        return Observable.create { observer in
            let parameters = ["i": id]
            let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/lookup.php", parameters: parameters)
                .validate()
                .responseDecodable(of: DrinkDetailResponse.self) { response in
                    switch response.result {
                    case .success(let drinkDetailResponse):
                        guard let drinkDetail = drinkDetailResponse.drinks.first else {
                            observer.onError(NSError(domain: "com.example.myApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to parse drink detail"]))
                            return
                        }
                        observer.onNext(drinkDetail)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
