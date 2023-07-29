//
//  Skill.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import Foundation
class Skill {
    let name: String
    var periods: [[Camper]]
    var leaders: [[Leader]]
    var maximums: [Int]
    init(name: String, periods: [[Camper]] = [[],[],[],[]], leaders: [[Leader]] = [[],[],[],[]], maximums: [Int]) throws {
        self.name = name
        if(periods.count != 4){
            throw SPRError.InvalidSize
        } else {
            self.periods = periods
        }
        if(leaders.count != 4){
            throw SPRError.InvalidSize
        } else {
            self.leaders = leaders
        }
        if(maximums.count != 4){
            throw SPRError.InvalidSize
        } else {
            self.maximums = maximums
        }
    }
}
