//
//  Skill.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Skill {
    let name: String
    var skillOne: [Camper]
    var skillOneLeaders: [Leader]
    var skillTwo: [Camper]
    var skillTwoLeaders: [Leader]
    var skillThree: [Camper]
    var skillThreeLeaders: [Leader]
    var skillFour: [Camper]
    var skillFourLeaders: [Leader]
    init(name: String, skillOne: [Camper] = [], skillOneLeaders: [Leader] = [], skillTwo: [Camper] = [], skillTwoLeaders: [Leader] = [], skillThree: [Camper] = [], skillThreeLeaders: [Leader] = [], skillFour: [Camper] = [], skillFourLeaders: [Leader] = []) {
        self.name = name
        self.skillOne = skillOne
        self.skillOneLeaders = skillOneLeaders
        self.skillTwo = skillTwo
        self.skillTwoLeaders = skillTwoLeaders
        self.skillThree = skillThree
        self.skillThreeLeaders = skillThreeLeaders
        self.skillFour = skillFour
        self.skillFourLeaders = skillFourLeaders
    }
}
