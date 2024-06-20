/*
 * Camp.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2024 Ranger Lake Bible Camp
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

class Camp: Codable {
    var campers: [Camper]
    var leaders: [Leader]
    var cabins: [String:Cabin]
    var skills: [String:Skill]
    var fanatics: [String:Fanatic]
    
    let nullSenior: Leader
    let nullJunior: Leader
    
    init(){
        self.campers = []
        self.leaders = []
        self.nullSenior = try! Leader(fName: "null", lName: "senior", cabin: "Unassigned", senior: true)
        self.nullJunior = try! Leader(fName: "null", lName: "junior", cabin: "Unassigned", senior: false)
        self.cabins = ["Unassigned": try! Cabin(name: "Unassigned", senior: self.nullSenior, junior: self.nullJunior, campers: [])]
        self.skills = ["None": try! Skill(name: "None", maximums: [255,255,255,255])]
        self.fanatics = [:]
    }
}
