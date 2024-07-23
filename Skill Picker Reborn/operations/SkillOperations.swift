/*
 * SkillOperations.swift
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

extension CampData {
    func createSkill(newSkill: Skill, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.skills[newSkill.name] = newSkill
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of createSkill")
            }
        }
    }
    
    func modifySkill(oldName: String, newName: String, newMaximums: [Int], usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(oldName == "None"){
            throw SPRError.NoneSkillRefusal
        }
        if(oldName != newName && self.c.skills.keys.contains(newName)){
            throw SPRError.DuplicateSkillName
        }
        if(newMaximums.count != 4){
            throw SPRError.InvalidSize
        }
        self.c.skills[oldName]!.maximums = newMaximums
        if(oldName != newName){
            for camper in self.c.campers {
                for i in 0...(camper.preferredSkills.count-1){
                    if(camper.preferredSkills[i] == oldName){
                        camper.preferredSkills[i] = newName
                    }
                }
                for i in 0...3 {
                    if(camper.skills[i] == oldName){
                        camper.skills[i] = newName
                    }
                }
            }
            self.c.skills[newName] = self.c.skills[oldName]
            self.c.skills.removeValue(forKey: oldName)
            self.c.skills[newName]!.name = newName
            for i in 0...3 {
                for leader in self.c.skills[newName]!.leaders[i] {
                    leader.skills[i] = newName
                }
            }
        }
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of modifySkill")
            }
        }
    }
    
    func deleteSkill(skillName: String, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(skillName == "None"){
            throw SPRError.RefusingDelete
        }
        for i in 0...3 {
            if(self.c.skills[skillName]!.maximums[i] != 0){
                for leader in self.c.skills[skillName]!.leaders[i] {
                    leader.skills[i] = "None"
                }
                for camper in self.c.skills[skillName]!.periods[i] {
                    camper.skills[i] = "None"
                }
            }
        }
        for camper in self.c.campers {
            for i in 0...(camper.preferredSkills.count-1){
                if(camper.preferredSkills[i] == skillName){
                    camper.preferredSkills.remove(at: i)
                    camper.preferredSkills.append("None")
                }
            }
        }
        self.c.skills.removeValue(forKey: skillName)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of deleteSkill")
            }
        }
    }
    
    func assignLeaderToSkill(targetLeader: Leader, skillName: String, period: Int, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.skills[targetLeader.skills[period]]!.leaders[period].remove(targetLeader)
        self.c.skills[skillName]!.leaders[period].insert(targetLeader)
        targetLeader.skills[period] = skillName
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of assignLeaderToSkill")
            }
        }
    }
    
    func removeLeaderFromSkill(leaderID: Leader.ID, skillName: String, period: Int, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(skillName == "None"){
            throw SPRError.RefusingDelete
        }
        self.c.skills[skillName]!.leaders[period].remove(self.getLeader(leaderID: leaderID)!)
        self.getLeader(leaderID: leaderID)!.skills[period] = "None"
        self.c.skills["None"]!.leaders[period].insert(self.getLeader(leaderID: leaderID)!)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of removeLeaderFromSkill")
            }
        }
    }
    
    func assignCamperToSkill(targetCamper: Camper, skillName: String, period: Int, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.skills[targetCamper.skills[period]]!.periods[period].remove(targetCamper)
        self.c.skills[skillName]!.periods[period].insert(targetCamper)
        targetCamper.skills[period] = skillName
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of assignCamperToSkill")
            }
        }
    }
    
    func removeCamperFromSkill(camperID: Camper.ID, skillName: String, period: Int, overrideFanaticWarning: Bool = false, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(skillName == "None"){
            throw SPRError.RefusingDelete
        }
        if(self.c.fanatics.keys.contains(skillName) && !overrideFanaticWarning){
            throw SPRError.SkillIsFanatic
        }
        self.c.skills[skillName]!.periods[period].remove(self.getCamper(camperID: camperID)!)
        self.getCamper(camperID: camperID)!.skills[period] = "None"
        self.c.skills["None"]!.periods[period].insert(self.getCamper(camperID: camperID)!)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of removeCamperFromSkill")
            }
        }
    }
    
    func clearAllCamperSkills(usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        for camper in self.c.campers {
            for i in 0...3 {
                do {
                    try self.removeCamperFromSkill(camperID: camper.id, skillName: camper.skills[i], period: i, usingInternally: true)
                } catch SPRError.RefusingDelete {
                    continue
                } catch SPRError.SkillIsFanatic {
                    continue
                } catch {
                    throw error
                }
            }
        }
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of clearAllCamperSkills")
            }
        }
    }
    
    func processTopSkills(usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        var skillPriority: [String:Int] = [:]
        
        for skill in self.c.skills.keys {
            if(skill != "None"){
                skillPriority[skill] = 0
            }
        }
        
        for camper in self.c.campers {
            if(camper.preferredSkills[0] != "None"){
                skillPriority[camper.preferredSkills[0]]! += 1
            }
        }
        
        for skill in skillPriority.keys.sorted(by: {skillPriority[$0]! > skillPriority[$1]!}) {
            for camper in self.c.campers {
                if(camper.preferredSkills[0] == skill && !camper.skills.contains(skill)){
                    var skillCaps: [Int?] = [nil,nil,nil,nil]
                    for i in 0...3 {
                        if(camper.skills[i] == "None" && self.c.skills[skill]!.maximums[i] > self.c.skills[skill]!.periods[i].count){
                            skillCaps[i] = self.c.skills[skill]!.periods[i].count
                        }
                    }
                    if(skillCaps != [nil,nil,nil,nil]){
                        var highestCount: Int = Int.min
                        var highestCountIndexes: [Int] = []
                        for (index, value) in skillCaps.enumerated() {
                            if let intValue = value {
                                if intValue > highestCount {
                                    highestCount = intValue
                                    highestCountIndexes = [index]
                                } else if intValue == highestCount {
                                    highestCountIndexes.append(index)
                                }
                            }
                        }
                        self.assignCamperToSkill(targetCamper: camper, skillName: skill, period: highestCountIndexes[Int.random(in: 0..<highestCountIndexes.count)], usingInternally: true)
                    }
                }
            }
        }
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
#warning("TODO: handle undo of processTopSkills")
            }
        }
    }
    
    func processPreferredSkills(usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(self.c.skills.count == 1){
            throw SPRError.NoSkills
        }
        var emptySpaces: Int
        for p in 0...3 {
            emptySpaces = 0
            for skill in self.c.skills.keys {
                if(skill != "None" && !self.c.fanatics.keys.contains(skill)){
                    emptySpaces += self.c.skills[skill]!.maximums[p]-self.c.skills[skill]!.periods[p].count
                }
            }
            if(emptySpaces - self.c.skills["None"]!.periods[p].count < 0){
                throw SPRError.NotEnoughSkillSpace
            }
        }
        try! self.processTopSkills(usingInternally: true)
        for p in 1...5 {
            for camper in self.c.campers {
                if(camper.skills.contains("None") && (camper.fanatic == "None" || p != 5)){
                    if(camper.preferredSkills[p] != "None" && !camper.skills.contains(camper.preferredSkills[p])){
                        var skillCaps: [Int?] = [nil,nil,nil,nil]
                        for i in 0...3 {
                            if(camper.skills[i] == "None" && self.c.skills[camper.preferredSkills[p]]!.maximums[i] > self.c.skills[camper.preferredSkills[p]]!.periods[i].count){
                                skillCaps[i] = self.c.skills[camper.preferredSkills[p]]!.periods[i].count
                            }
                        }
                        if(skillCaps != [nil,nil,nil,nil]){
                            var highestCount: Int = Int.min
                            var highestCountIndexes: [Int] = []
                            for (index, value) in skillCaps.enumerated() {
                                if let intValue = value {
                                    if intValue > highestCount {
                                        highestCount = intValue
                                        highestCountIndexes = [index]
                                    } else if intValue == highestCount {
                                        highestCountIndexes.append(index)
                                    }
                                }
                            }
                            self.assignCamperToSkill(targetCamper: camper, skillName: camper.preferredSkills[p], period: highestCountIndexes[Int.random(in: 0..<highestCountIndexes.count)], usingInternally: true)
                        }
                    }
                }
            }
        }
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of processPreferredSkills")
            }
        }
    }
    
    func skillIsOverMax(oldSkill: String, newSkill: String, skillPeriod: Int) -> Bool {
        if(self.c.fanatics.keys.contains(newSkill) || newSkill == "None" || newSkill == ""){
            return false
        } else {
            return self.c.skills[newSkill]!.maximums[skillPeriod] < self.c.skills[newSkill]!.periods[skillPeriod].count+(oldSkill == newSkill ? 0 : 1)
        }
    }
}
