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
    @Published var c: Camp
    
    let undoManager: UndoManager
    
    @Published var selectedCabin: String
    @Published var cabinCamperSortOrder: [KeyPathComparator<Camper>]
    @Published var camperSortOrder: [KeyPathComparator<Camper>]
    @Published var leaderSortOrder: [KeyPathComparator<Leader>]
    @Published var selectedSkill: String
    @Published var selectedPeriod: Int
    @Published var skillCamperSortOrder: [KeyPathComparator<Camper>]
    @Published var skillLeaderSortOrder: [KeyPathComparator<Leader>]
    
    @Published var importSkillList: [String:Bool]
    @Published var importSkillDemand: [String:[Int]]
    @Published var isImporting: Bool
    
    @Published var genericErrorAlert: Bool
    @Published var genericErrorDesc: String
    
    func getCamper(camperID: Camper.ID) -> Camper? {
        return self.c.campers.first(where: {$0.id == camperID})
    }
    
    func getLeader(leaderID: Leader.ID) -> Leader? {
        return self.c.leaders.first(where: {$0.id == leaderID})
    }
    
    init(){
        self.c = Camp()
        
        self.undoManager = UndoManager()
        
        self.selectedCabin = "Unassigned"
        self.cabinCamperSortOrder = [KeyPathComparator(\Camper.lName)]
        self.camperSortOrder = [KeyPathComparator(\Camper.lName)]
        self.leaderSortOrder = [KeyPathComparator(\Leader.lName)]
        self.selectedSkill = "None"
        self.selectedPeriod = 0
        self.skillCamperSortOrder = [KeyPathComparator(\Camper.lName)]
        self.skillLeaderSortOrder = [KeyPathComparator(\Leader.lName)]
        
        self.importSkillList = [:]
        self.importSkillDemand = [:]
        self.isImporting = false
        
        self.genericErrorAlert = false
        self.genericErrorDesc = ""
    }
}
