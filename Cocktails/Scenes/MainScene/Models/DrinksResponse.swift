//
//  DrinksResponse.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import Foundation

struct DrinksResponse: Decodable {
    let drinks: [Drink]
}

struct Drink: Decodable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}
