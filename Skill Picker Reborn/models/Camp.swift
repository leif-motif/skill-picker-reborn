/*
 * Camp.swift
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

class Camp: Codable {
    var campers: Set<Camper>
    var leaders: Set<Leader>
    var cabins: [String:Cabin]
    var skills: [String:Skill]
    var fanatics: [String:Fanatic]
    
    let nullSenior: Leader
    let nullJunior: Leader
    
    let version: String
    let id: UUID
    
    init(){
        self.campers = []
        self.leaders = []
        self.nullSenior = try! Leader(fName: "null", lName: "senior", cabin: "Unassigned", senior: true)
        self.nullJunior = try! Leader(fName: "null", lName: "junior", cabin: "Unassigned", senior: false)
        self.cabins = ["Unassigned": try! Cabin(name: "Unassigned", senior: self.nullSenior, junior: self.nullJunior, campers: [])]
        self.skills = ["None": try! Skill(name: "None", maximums: [255,255,255,255])]
        self.fanatics = [:]
        self.version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        self.id = UUID()
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.campers = try container.decode(Set<Camper>.self, forKey: .campers)
        self.leaders = try container.decode(Set<Leader>.self, forKey: .leaders)
        self.nullSenior = try container.decode(Leader.self, forKey: .nullSenior)
        self.nullJunior = try container.decode(Leader.self, forKey: .nullJunior)
        let cabinReference = try container.decode([String : Cabin].self, forKey: .cabins)
        self.cabins = ["Unassigned":try! Cabin(name: "Unassigned", senior: self.nullSenior, junior: self.nullJunior)]
        for cabin in cabinReference.values {
            if(cabin.name != "Unassigned"){
                self.cabins[cabin.name] = try! Cabin(name: cabin.name,
                                                     senior: self.leaders.first(where: {$0.id == cabin.senior.id}) ?? nullSenior,
                                                     junior: self.leaders.first(where: {$0.id == cabin.junior.id}) ?? nullJunior)
            }
            for camper in cabin.campers {
                self.cabins[cabin.name]!.campers.insert(self.campers.first(where: {$0.id == camper.id})!)
            }
        }
        let skillReference = try container.decode([String : Skill].self, forKey: .skills)
        self.skills = [:]
        for skill in skillReference.values {
            self.skills[skill.name] = try! Skill(name: skill.name, maximums: skill.maximums)
            for i in 0...3 {
                for camper in skill.periods[i] {
                    self.skills[skill.name]!.periods[i].insert(self.campers.first(where: {$0.id == camper.id})!)
                }
                for leader in skill.leaders[i] {
                    self.skills[skill.name]!.leaders[i].insert(self.leaders.first(where: {$0.id == leader.id})!)
                }
            }
        }
        self.fanatics = try container.decode([String : Fanatic].self, forKey: .fanatics)
        let fileVersion = try container.decode(String.self, forKey: .version)
        if(!supportedVersions.contains(fileVersion)){
            throw SPRError.UnsupportedVersion(fileVersion)
        }
        self.version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        self.id = try container.decode(UUID.self, forKey: .id)
    }
}
