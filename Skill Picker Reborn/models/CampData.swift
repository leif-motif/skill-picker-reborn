/*
 * CampData.swift
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

class CampData: ObservableObject {
    @Published var campers: [Camper]
    @Published var leaders: [Leader]
    @Published var cabins: [String:Cabin]
    @Published var skills: [String:Skill]
    @Published var fanatics: [String:Fanatic]
    
    let nullSenior: Leader
    let nullJunior: Leader
    
    @Published var selectedCabin: String
    @Published var cabinCamperSortOrder: [KeyPathComparator<Camper>]
    @Published var camperSortOrder: [KeyPathComparator<Camper>]
    @Published var leaderSortOrder: [KeyPathComparator<Leader>]
    @Published var selectedSkill: String
    @Published var selectedPeriod: Int
    @Published var skillCamperSortOrder: [KeyPathComparator<Camper>]
    @Published var skillLeaderSortOrder: [KeyPathComparator<Leader>]
    
    @Published var importSkillList: [String:Bool]
    @Published var isImporting: Bool
    
    init(){
        self.campers = []
        self.leaders = []
        self.nullSenior = try! Leader(fName: "null", lName: "senior", cabin: "Unassigned", senior: true)
        self.nullJunior = try! Leader(fName: "null", lName: "junior", cabin: "Unassigned", senior: false)
        self.cabins = ["Unassigned": try! Cabin(name: "Unassigned", senior: self.nullSenior, junior: self.nullJunior, campers: [])]
        self.skills = ["None": try! Skill(name: "None", maximums: [255,255,255,255])]
        self.fanatics = [:]
        self.selectedCabin = "Unassigned"
        self.cabinCamperSortOrder = [KeyPathComparator(\Camper.lName)]
        self.camperSortOrder = [KeyPathComparator(\Camper.lName)]
        self.leaderSortOrder = [KeyPathComparator(\Leader.lName)]
        self.selectedSkill = "None"
        self.selectedPeriod = 0
        self.skillCamperSortOrder = [KeyPathComparator(\Camper.lName)]
        self.skillLeaderSortOrder = [KeyPathComparator(\Leader.lName)]
        self.importSkillList = [:]
        self.isImporting = false
    }
}
