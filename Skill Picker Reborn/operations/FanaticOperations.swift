/*
 * FanaticOperations.swift
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

extension CampData {
    func createFanatic(newFanatic: Fanatic, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.fanatics[newFanatic.name] = newFanatic
        self.c.skills[newFanatic.name] = try! Skill(name: newFanatic.name, maximums: [newFanatic.activePeriods[0] ? 255 : 0,
                                                                                      newFanatic.activePeriods[1] ? 255 : 0,
                                                                                      newFanatic.activePeriods[2] ? 255 : 0,
                                                                                      newFanatic.activePeriods[3] ? 255 : 0])
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: handle undo of createFanatic")
            }
        }
    }
    
    func renameFanatic(oldName: String, newName: String, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        for i in 0...3 {
            for camper in self.c.skills[oldName]!.periods[i] {
                if(camper.skills[i] == oldName){
                    camper.skills[i] = newName
                }
                camper.fanatic = newName
            }
        }
        for i in 0...3 {
            for leader in self.c.skills[oldName]!.leaders[i] {
                if(leader.skills[i] == oldName){
                    leader.skills[i] = newName
                }
            }
        }
        self.c.skills[newName] = self.c.skills[oldName]
        self.c.skills.removeValue(forKey: oldName)
        self.c.skills[newName]!.name = newName
        self.c.fanatics[newName] = self.c.fanatics[oldName]
        self.c.fanatics.removeValue(forKey: oldName)
        self.c.fanatics[newName]!.name = newName
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in renameFanatic")
            }
        }
    }
    
    func changeFanaticPeriods(targetFanatic: String, newPeriods: [Bool], usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(newPeriods.count != 4){
            throw SPRError.InvalidSize
        }
        var camperFanatics: Set<Camper>?
        //find list of campers to use
        for i in 0...3 {
            if(self.c.fanatics[targetFanatic]!.activePeriods[i]){
                camperFanatics = self.c.skills[targetFanatic]!.periods[i]
                break
            }
        }
        for i in 0...3 {
            if(self.c.fanatics[targetFanatic]!.activePeriods[i] && !newPeriods[i]){
                for camper in self.c.skills[targetFanatic]!.periods[i] {
                    camper.skills[i] = "None"
                    self.c.skills["None"]!.periods[i].insert(camper)
                }
                for leader in self.c.skills[targetFanatic]!.leaders[i] {
                    leader.skills[i] = "None"
                    self.c.skills["None"]!.leaders[i].insert(leader)
                }
                self.c.skills[targetFanatic]!.periods[i] = []
                self.c.skills[targetFanatic]!.leaders[i] = []
                self.c.skills[targetFanatic]!.maximums[i] = 0
            } else if(!self.c.fanatics[targetFanatic]!.activePeriods[i] && newPeriods[i]){
                self.c.skills[targetFanatic]!.maximums[i] = 255
                for camper in camperFanatics! {
                    if(camper.skills[i] != "None"){
                        try! self.removeCamperFromSkill(camperID: camper.id, skillName: camper.skills[i], period: i, overrideFanaticWarning: true, usingInternally: true)
                    }
                    self.assignCamperToSkill(targetCamper: camper, skillName: targetFanatic, period: i, usingInternally: true)
                }
            }
        }
        self.c.fanatics[targetFanatic]!.activePeriods = newPeriods
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in changeFanaticPeriods")
            }
        }
    }
    
    func deleteFanatic(fanaticName: String, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(fanaticName == "None"){
            throw SPRError.NoneSkillRefusal
        }
        try! self.deleteSkill(skillName: fanaticName, usingInternally: true)
        self.c.fanatics.removeValue(forKey: fanaticName)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in deleteFanatic")
            }
        }
    }
    
    func assignCamperToFanatic(targetCamper: Camper, fanaticName: String, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(fanaticName == "None"){
            throw SPRError.NoneSkillRefusal
        }
        for i in 0...3 {
            if(self.c.fanatics[fanaticName]!.activePeriods[i]){
                self.c.skills[targetCamper.skills[i]]!.periods[i].remove(targetCamper)
                targetCamper.skills[i] = fanaticName
                self.c.skills[fanaticName]!.periods[i].insert(targetCamper)
            }
        }
        targetCamper.fanatic = fanaticName
        targetCamper.preferredSkills.remove(at: 5)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in assignCamperToFanatic")
            }
        }
    }
    
    func removeCamperFromFanatic(camperID: Camper.ID, fanaticName: String, newSixthPreferredSkill: String, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(fanaticName == "None"){
            throw SPRError.NoneSkillRefusal
        }
        for i in 0...3 {
            if(self.c.fanatics[fanaticName]!.activePeriods[i]){
                self.c.skills[fanaticName]!.periods[i].remove(self.getCamper(camperID: camperID)!)
                self.getCamper(camperID: camperID)!.skills[i] = "None"
                self.c.skills["None"]!.periods[i].insert(self.getCamper(camperID: camperID)!)
            }
        }
        self.getCamper(camperID: camperID)!.fanatic = "None"
        self.getCamper(camperID: camperID)!.preferredSkills.append(newSixthPreferredSkill)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in removeCamperFromFanatic")
            }
        }
    }
    
    func evaluateFanatics(fanatic: String, periods: [String]) throws -> Bool {
        //this returns true if the camper does not contain any fanatic skills it shouldn't have
        if(periods.count != 4){
            throw SPRError.InvalidSize
        }
        if(fanatic == "None"){
            return !periods.contains { key in
                self.c.fanatics.keys.contains(key)
            }
        } else {
            var valid = true
            for i in 0...3 {
                if(self.c.fanatics.keys.contains(periods[i]) && fanatic != periods[i] && !self.c.fanatics[fanatic]!.activePeriods[i]){
                    valid = false
                    break
                }
            }
            return valid
        }
    }
    
    func isNotFanaticOrIsRunning(skillName: String, period: Int) -> Bool {
        if(!self.c.fanatics.keys.contains(skillName)){
            return true
        }
        return self.c.fanatics[skillName]!.activePeriods[period]
    }
}
