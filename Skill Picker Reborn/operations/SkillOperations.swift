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

func createSkill(newSkill: Skill, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.skills[newSkill.name] = newSkill
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of createSkill")
        }
    }
}

func modifySkill(oldName: String, newName: String, newMaximums: [Int], data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(oldName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    if(data.c.skills.keys.contains(newName)){
        throw SPRError.DuplicateSkillName
    }
    if(newMaximums.count != 4){
        throw SPRError.InvalidSize
    }
    data.c.skills[oldName]!.maximums = newMaximums
    for camper in data.c.campers {
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
    data.c.skills[newName] = data.c.skills[oldName]
    data.c.skills.removeValue(forKey: oldName)
    data.c.skills[newName]!.name = newName
    for i in 0...3 {
        for leader in data.c.skills[newName]!.leaders[i] {
            leader.skills[i] = newName
        }
    }
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of modifySkill")
        }
    }
}

func deleteSkill(skillName: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    for i in 0...3 {
        if(data.c.skills[skillName]!.maximums[i] != 0){
            for leader in data.c.skills[skillName]!.leaders[i] {
                leader.skills[i] = "None"
            }
            for camper in data.c.skills[skillName]!.periods[i] {
                camper.skills[i] = "None"
            }
        }
    }
    for camper in data.c.campers {
        for i in 0...(camper.preferredSkills.count-1){
            if(camper.preferredSkills[i] == skillName){
                camper.preferredSkills.remove(at: i)
                camper.preferredSkills.append("None")
            }
        }
    }
    data.c.skills.removeValue(forKey: skillName)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of deleteSkill")
        }
    }
}

func assignLeaderToSkill(targetLeader: Leader, skillName: String, period: Int, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.skills[targetLeader.skills[period]]!.leaders[period].removeAll(where: {$0 == targetLeader})
    data.c.skills[skillName]!.leaders[period].append(targetLeader)
    targetLeader.skills[period] = skillName
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of assignLeaderToSkill")
        }
    }
}

func removeLeaderFromSkill(leaderID: Leader.ID, skillName: String, period: Int, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    data.c.skills[skillName]!.leaders[period].removeAll(where: {$0.id == leaderID})
    data.c.leaders.first(where: {$0.id == leaderID})!.skills[period] = "None"
    data.c.skills["None"]!.leaders[period].append(data.c.leaders.first(where: {$0.id == leaderID})!)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of removeLeaderFromSkill")
        }
    }
}

func assignCamperToSkill(targetCamper: Camper, skillName: String, period: Int, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.skills[targetCamper.skills[period]]!.periods[period].removeAll(where: {$0 == targetCamper})
    data.c.skills[skillName]!.periods[period].append(targetCamper)
    targetCamper.skills[period] = skillName
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of assignCamperToSkill")
        }
    }
}

func removeCamperFromSkill(camperID: Camper.ID, skillName: String, period: Int, data: CampData, overrideFanaticWarning: Bool = false, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    if(data.c.fanatics.keys.contains(skillName) && !overrideFanaticWarning){
        throw SPRError.SkillIsFanatic
    }
    data.c.skills[skillName]!.periods[period].removeAll(where: {$0.id == camperID})
    data.c.campers.first(where: {$0.id == camperID})!.skills[period] = "None"
    data.c.skills["None"]!.periods[period].append(data.c.campers.first(where: {$0.id == camperID})!)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of removeCamperFromSkill")
        }
    }
}

func clearAllCamperSkills(data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    for camper in data.c.campers {
        for i in 0...3 {
            do {
                try removeCamperFromSkill(camperID: camper.id, skillName: camper.skills[i], period: i, data: data, usingInternally: true)
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
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of clearAllCamperSkills")
        }
    }
}

func processPreferredSkills(data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(data.c.skills.count == 1){
        throw SPRError.NoSkills
    }
    var emptySpaces: Int
    for p in 0...3 {
        emptySpaces = 0
        for skill in data.c.skills.keys {
            if(skill != "None" && !data.c.fanatics.keys.contains(skill)){
                emptySpaces += data.c.skills[skill]!.maximums[p]-data.c.skills[skill]!.periods[p].count
            }
        }
        if(emptySpaces - data.c.skills["None"]!.periods[p].count < 0){
            throw SPRError.NotEnoughSkillSpace
        }
    }
    for p in 0...5 {
        for camper in data.c.campers {
            if(camper.skills.contains("None") && (camper.fanatic == "None" || p != 5)){
                if(camper.preferredSkills[p] != "None"){
                    var skillCaps: [Int?] = [nil,nil,nil,nil]
                    for i in 0...3 {
                        if(camper.skills[i] == "None" && data.c.skills[camper.preferredSkills[p]]!.maximums[i] > data.c.skills[camper.preferredSkills[p]]!.periods[i].count){
                            skillCaps[i] = data.c.skills[camper.preferredSkills[p]]!.periods[i].count
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
                        assignCamperToSkill(targetCamper: camper, skillName: camper.preferredSkills[p], period: highestCountIndexes[Int.random(in: 0..<highestCountIndexes.count)], data: data, usingInternally: true)
                    }
                }
            }
        }
    }
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of processPreferredSkills")
        }
    }
}

func skillIsOverMax(oldSkill: String, newSkill: String, skillPeriod: Int, camp: Camp) -> Bool {
    if(camp.fanatics.keys.contains(newSkill) || newSkill == "None" || newSkill == ""){
        return false
    } else {
        return camp.skills[newSkill]!.maximums[skillPeriod] < camp.skills[newSkill]!.periods[skillPeriod].count+(oldSkill == newSkill ? 0 : 1)
    }
}
