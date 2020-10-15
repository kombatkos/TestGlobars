//
//  UserData.swift
//  TestGlobars
//
//  Created by Konstantin Porokhov on 08.10.2020.
//

import Foundation


struct UserData: Decodable {
    let success: Bool?
    let data: [UserID]
}

struct UserID: Decodable {
    let id: String?
}

struct mapData {
    
}
