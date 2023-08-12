/*
 * Skill.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2023 Ranger Lake Bible Camp
 *
 * Skill Picker Reborn is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Skill Picker Reborn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Skill Picker Reborn; if not, see <https://www.gnu.org/licenses/>.
 */

import Foundation
class Skill {
    var name: String
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
