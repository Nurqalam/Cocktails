//
//  DrinksViewModel.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import RxSwift
import RxCocoa
import Kingfisher
import Foundation

class DrinksViewModel {
    private let disposeBag = DisposeBag()
    private var cache: [String: [Drink]] = [:]

    let drinks = BehaviorRelay<[Drink]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let searchText = BehaviorRelay<String>(value: "")

    func fetchDrinks(for category: String, filter: String = "") {
        let categoryKey = category.replacingOccurrences(of: "-", with: "_")

        if let cachedDrinks = cache[categoryKey] {
            let filteredDrinks = filter.isEmpty ? cachedDrinks : cachedDrinks.filter { $0.strDrink.lowercased().contains(filter.lowercased()) }
            drinks.accept(filteredDrinks)
            return
        }

        isLoading.accept(true)
        NetworkService.shared.fetchDrinks(for: categoryKey)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] drinksResponse in
                guard let self = self else { return }

                let drinks = drinksResponse.drinks
                self.cache[categoryKey] = drinks

                let filteredDrinks = filter.isEmpty ? drinks : drinks.filter { $0.strDrink.lowercased().contains(filter.lowercased()) }
                self.drinks.accept(filteredDrinks)

                let urls = drinks.compactMap { URL(string: $0.strDrinkThumb) }
                ImagePrefetcher(urls: urls).start()

                Observable.just(())
                    .delay(.seconds(1), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { _ in
                        self.isLoading.accept(false)
                    })
                    .disposed(by: self.disposeBag)
            }, onError: { [weak self] error in
                print(error)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchDrinksForRefresh(for category: String, filter: String = "") {
        let categoryKey = category.replacingOccurrences(of: "-", with: "_")

        if let cachedDrinks = cache[categoryKey] {
            let filteredDrinks = filter.isEmpty ? cachedDrinks : cachedDrinks.filter { $0.strDrink.lowercased().contains(filter.lowercased()) }
            drinks.accept(filteredDrinks.shuffled())
            return
        }

        isLoading.accept(true)
        NetworkService.shared.fetchDrinks(for: categoryKey)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] drinksResponse in
                guard let self = self else { return }

                var drinks = drinksResponse.drinks
                drinks.shuffle()
                self.cache[categoryKey] = drinks

                let filteredDrinks = filter.isEmpty ? drinks : drinks.filter { $0.strDrink.lowercased().contains(filter.lowercased()) }
                self.drinks.accept(filteredDrinks)

                let urls = drinks.compactMap { URL(string: $0.strDrinkThumb) }
                ImagePrefetcher(urls: urls).start()

                Observable.just(())
                    .delay(.seconds(1), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { _ in
                        self.isLoading.accept(false)
                    })
                    .disposed(by: self.disposeBag)
            }, onError: { [weak self] error in
                print(error)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
