//
//  ListObject.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 09.10.2020.
//

import Foundation

struct ListCars {
    let success: Bool?
    let data: [Car]?
}

struct Car {
    let id: String
    let name: String
    let checked: Bool
    let detail: Bool
    let position: Location
    let eye: Bool
    let color: String?
    let icon: Data
    let rotate: Bool
}

struct Location {
    let u: String
    let t: Date
    let lt: Double
    let ln: Double
    let s: Int
    let b: Int
    let i: Bool
    let m: Date
}
