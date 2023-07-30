//
//  Fanatic.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-28.
//

import Foundation

class Fanatic {
    let name: String
    let activePeriods: [Bool]
    init(name: String, activePeriods: [Bool]) throws {
        self.name = name
        if(activePeriods.count != 4){
            throw SPRError.InvalidSize
        } else {
            self.activePeriods = activePeriods
        }
    }
}
