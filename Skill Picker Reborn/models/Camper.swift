/*
 * Camper.swift
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
class Camper: Human {
    var preferredSkills: [String]
    var fanatic: String
    init(fName: String, lName: String, cabin: String, preferredSkills: [String], fanatic: String, skills: [String] = ["None", "None", "None", "None"]) throws {
        self.fanatic = fanatic
        if((preferredSkills.count != 6 && fanatic == "None") || (preferredSkills.count != 5 && fanatic != "None")){
            throw SPRError.InvalidSize
        } else {
            self.preferredSkills = preferredSkills
        }
        try! super.init(fName: fName, lName: lName, cabin: cabin, skills: skills)
    }
}
