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
}
