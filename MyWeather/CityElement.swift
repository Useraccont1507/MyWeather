//
//  Model.swift
//  MyWeather
//
//  Created by Illia Verezei on 19.11.2024.
//

import Foundation

struct CityElement: Codable {
    let placeID: Int
    let licence, osmType: String
    let osmID: Int
    let lat, lon, cityClass, type: String
    let placeRank: Int
    let importance: Double
    let addresstype, name, displayName: String
    let boundingbox: [String]

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case lat, lon
        case cityClass = "class"
        case type
        case placeRank = "place_rank"
        case importance, addresstype, name
        case displayName = "display_name"
        case boundingbox
    }
}

typealias City = [CityElement]


