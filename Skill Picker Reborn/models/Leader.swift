/*
 * Leader.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2025 Ranger Lake Bible Camp
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

class Leader: Human {
    let senior: Bool
    
    init(fName: String, lName: String, cabin: String = "Unassigned", senior: Bool, skills: [String] = ["None", "None", "None", "None"]) throws {
        self.senior = senior
        try! super.init(fName: fName, lName: lName, cabin: cabin, skills: skills)
    }
    
    enum CodingKeys: String, CodingKey {
        case senior
    }
    
    override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(senior, forKey: .senior)
        
        let superencoder = container.superEncoder()
        try super.encode(to: superencoder)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.senior = try container.decode(Bool.self, forKey: .senior)
        
        let superDecoder = try! container.superDecoder()
        try! super.init(from: superDecoder)
    }
}
