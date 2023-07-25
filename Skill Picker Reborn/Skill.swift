//
//  Skill.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Skill {
    struct Period {
        let min: Int
        let max: Int
        var leaders: [Leader]
        var campers: [Camper]
    }
    let name: String
    var skillOne: Period
    var skillTwo: Period
    var skillThree: Period
    var skillFour: Period
    init(name: String, skillOne: Period, skillTwo: Period, skillThree: Period, skillFour: Period) {
        self.name = name
        self.skillOne = skillOne
        self.skillTwo = skillTwo
        self.skillThree = skillThree
        self.skillFour = skillFour
    }
}
