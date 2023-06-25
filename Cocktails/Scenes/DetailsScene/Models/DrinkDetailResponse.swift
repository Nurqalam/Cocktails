//
//  DrinkDetailResponse.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import Foundation

struct DrinkDetailResponse: Decodable {
    let drinks: [DrinkDetail]
}

struct DrinkDetail: Decodable {
    let idDrink: String
    let strDrink: String
    let strAlcoholic: String
    let strGlass: String
    let strInstructions: String
    let strDrinkThumb: String
}
