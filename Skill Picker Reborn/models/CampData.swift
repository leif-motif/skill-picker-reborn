/*
 * CampData.swift
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
    
    @Published var ignoreIdiotsConfirm: Bool
    @Published var clearSkillsConfirm: Bool
    @Published var genericErrorAlert: Bool
    @Published var addCamperSheet: Bool
    @Published var addLeaderSheet: Bool
    @Published var addCabinSheet: Bool
    @Published var addSkillSheet: Bool
    @Published var addFanaticSheet: Bool
    @Published var importSkillSheet: Bool
    
    var importSkillList: [String:Bool]
    var importSkillDemand: [String:[Int]]
    var isImporting: Bool
    var genericErrorDesc: String
    var csvInput: [Substring]
    var majorIdiots: [String]
    var idiots: [String]
    
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
        
        self.ignoreIdiotsConfirm = false
        self.clearSkillsConfirm = false
        self.genericErrorAlert = false
        self.addCamperSheet = false
        self.addLeaderSheet = false
        self.addCabinSheet = false
        self.addSkillSheet = false
        self.addFanaticSheet = false
        self.importSkillSheet = false
        
        self.importSkillList = [:]
        self.importSkillDemand = [:]
        self.isImporting = false
        self.genericErrorDesc = ""
        self.csvInput = [""]
        self.majorIdiots = [""]
        self.idiots = [""]
    }
}
