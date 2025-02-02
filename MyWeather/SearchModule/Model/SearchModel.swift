//
//  Model.swift
//  MyWeather
//
//  Created by Illia Verezei on 30.01.2025.
//

import Foundation

struct CityElement: Codable {
    let placeID: Int
    let licence, osmType: String
    let osmID: Int
    let lat, lon, cityElementClass, type: String
    let placeRank: Int
    let importance: Double
    let addresstype, name, displayName: String
    let address: Address
    let boundingbox: [String]

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case lat, lon
        case cityElementClass = "class"
        case type
        case placeRank = "place_rank"
        case importance, addresstype, name
        case displayName = "display_name"
        case address, boundingbox
    }
}


struct Address: Codable {
    let city, iso31662Lvl4, country, countryCode: String

    enum CodingKeys: String, CodingKey {
        case city
        case iso31662Lvl4 = "ISO3166-2-lvl4"
        case country
        case countryCode = "country_code"
    }
}
