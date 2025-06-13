/*
 * Human.swift
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

class Human: Identifiable, Equatable, Hashable, Codable {
    let id: UUID
    var fName: String
    var lName: String
    var cabin: String
    var skills: [String]
    
    init(fName: String, lName: String, cabin: String = "Unassigned", skills: [String] = ["None", "None", "None", "None"]) throws {
        self.id = UUID()
        self.fName = fName
        self.lName = lName
        self.cabin = cabin
        if(skills.count != 4){
            throw SPRError.InvalidSize
        }
        self.skills = skills
    }
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fName = "first_name"
        case lName = "last_name"
        case cabin
        case skills
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.fName = try container.decode(String.self, forKey: .fName)
        self.lName = try container.decode(String.self, forKey: .lName)
        self.cabin = try container.decode(String.self, forKey: .cabin)
        self.skills = try container.decode([String].self, forKey: .skills)
    }
}

//ideally this should not exist, but we need it to pass this data to views
struct HumanSelection<H: Human>: Identifiable {
    //why does this have to be identifiable again?
    let id = UUID()
    let selection: Set<H.ID>
}
