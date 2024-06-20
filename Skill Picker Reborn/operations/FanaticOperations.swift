/*
 * FanaticOperations.swift
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

func createFanatic(newFanatic: Fanatic, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.fanatics[newFanatic.name] = newFanatic
    data.c.skills[newFanatic.name] = try! Skill(name: newFanatic.name, maximums: [newFanatic.activePeriods[0] ? 255 : 0,
                                                                                  newFanatic.activePeriods[1] ? 255 : 0,
                                                                                  newFanatic.activePeriods[2] ? 255 : 0,
                                                                                  newFanatic.activePeriods[3] ? 255 : 0])
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: handle undo of createFanatic")
        }
    }
}

func renameFanatic(oldName: String, newName: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    for i in 0...3 {
        for camper in data.c.skills[oldName]!.periods[i] {
            if(camper.skills[i] == oldName){
                camper.skills[i] = newName
            }
            camper.fanatic = newName
        }
    }
    for i in 0...3 {
        for leader in data.c.skills[oldName]!.leaders[i] {
            if(leader.skills[i] == oldName){
                leader.skills[i] = newName
            }
        }
    }
    data.c.skills[newName] = data.c.skills[oldName]
    data.c.skills.removeValue(forKey: oldName)
    data.c.skills[newName]!.name = newName
    data.c.fanatics[newName] = data.c.fanatics[oldName]
    data.c.fanatics.removeValue(forKey: oldName)
    data.c.fanatics[newName]!.name = newName
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in renameFanatic")
        }
    }
}

func changeFanaticPeriods(targetFanatic: String, newPeriods: [Bool], data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(newPeriods.count != 4){
        throw SPRError.InvalidSize
    }
    var camperFanatics: [Camper]?
    var leaderFanatics: [Leader]?
    //find list of campers to use
    for i in 0...3 {
        if(data.c.fanatics[targetFanatic]!.activePeriods[i]){
            camperFanatics = data.c.skills[targetFanatic]!.periods[i]
            leaderFanatics = data.c.skills[targetFanatic]!.leaders[i]
            break
        }
    }
    for i in 0...3 {
        if(data.c.fanatics[targetFanatic]!.activePeriods[i] && !newPeriods[i]){
            for camper in data.c.skills[targetFanatic]!.periods[i] {
                camper.skills[i] = "None"
                data.c.skills["None"]!.periods[i].append(camper)
            }
            for leader in data.c.skills[targetFanatic]!.leaders[i] {
                leader.skills[i] = "None"
                data.c.skills["None"]!.leaders[i].append(leader)
            }
            data.c.skills[targetFanatic]!.periods[i] = []
            data.c.skills[targetFanatic]!.leaders[i] = []
            data.c.skills[targetFanatic]!.maximums[i] = 0
        } else if(!data.c.fanatics[targetFanatic]!.activePeriods[i] && newPeriods[i]){
            data.c.skills[targetFanatic]!.maximums[i] = 255
            for camper in camperFanatics! {
                if(camper.skills[i] != "None"){
                    try! removeCamperFromSkill(camperID: camper.id, skillName: camper.skills[i], period: i, data: data)
                }
                assignCamperToSkill(targetCamper: camper, skillName: targetFanatic, period: i, data: data)
            }
            for leader in leaderFanatics! {
                if(leader.skills[i] != "None"){
                    try! removeLeaderFromSkill(leaderID: leader.id, skillName: leader.skills[i], period: i, data: data)
                }
                assignLeaderToSkill(targetLeader: leader, skillName: targetFanatic, period: i, data: data)
            }
        }
    }
    data.c.fanatics[targetFanatic]!.activePeriods = newPeriods
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in changeFanaticPeriods")
        }
    }
}

func deleteFanatic(fanaticName: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    try! deleteSkill(skillName: fanaticName, data: data)
    data.c.fanatics.removeValue(forKey: fanaticName)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in deleteFanatic")
        }
    }
}

func assignLeaderToFanatic(targetLeader: Leader, fanaticName: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(data.c.fanatics[fanaticName]!.activePeriods[i]){
            data.c.skills[targetLeader.skills[i]]!.leaders[i].removeAll(where: {$0 == targetLeader})
            targetLeader.skills[i] = fanaticName
            data.c.skills[fanaticName]!.leaders[i].append(targetLeader)
        }
    }
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in assignLeaderToFanatic")
        }
    }
}

func removeLeaderFromFanatic(leaderID: Leader.ID, fanaticName: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(data.c.fanatics[fanaticName]!.activePeriods[i]){
            data.c.skills[fanaticName]!.leaders[i].removeAll(where: {$0.id == leaderID})
            data.c.leaders.first(where: {$0.id == leaderID})!.skills[i] = "None"
            data.c.skills["None"]!.leaders[i].append(data.c.leaders.first(where: {$0.id == leaderID})!)
        }
    }
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in removeLeaderFromFanatic")
        }
    }
}

func assignCamperToFanatic(targetCamper: Camper, fanaticName: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(data.c.fanatics[fanaticName]!.activePeriods[i]){
            data.c.skills[targetCamper.skills[i]]!.periods[i].removeAll(where: {$0 == targetCamper})
            targetCamper.skills[i] = fanaticName
            data.c.skills[fanaticName]!.periods[i].append(targetCamper)
        }
    }
    targetCamper.fanatic = fanaticName
    targetCamper.preferredSkills.remove(at: 5)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in assignCamperToFanatic")
        }
    }
}

func removeCamperFromFanatic(camperID: Camper.ID, fanaticName: String, newSixthPreferredSkill: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(data.c.fanatics[fanaticName]!.activePeriods[i]){
            data.c.skills[fanaticName]!.periods[i].removeAll(where: {$0.id == camperID})
            data.c.campers.first(where: {$0.id == camperID})!.skills[i] = "None"
            data.c.skills["None"]!.periods[i].append(data.c.campers.first(where: {$0.id == camperID})!)
        }
    }
    data.c.campers.first(where: {$0.id == camperID})!.fanatic = "None"
    data.c.campers.first(where: {$0.id == camperID})!.preferredSkills.append(newSixthPreferredSkill)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in removeCamperFromFanatic")
        }
    }
}

func evaluateFanatics(fanatic: String, periods: [String], data: CampData) throws -> Bool {
    //this returns true if the camper does not contain any fanatic skills it shouldn't have
    if(periods.count != 4){
        throw SPRError.InvalidSize
    }
    if(fanatic == "None"){
        return !periods.contains { key in
            data.c.fanatics.keys.contains(key)
        }
    } else {
        var valid = true
        for i in 0...3 {
            if(data.c.fanatics.keys.contains(periods[i]) && fanatic != periods[i] && !data.c.fanatics[fanatic]!.activePeriods[i]){
                valid = false
                break
            }
        }
        return valid
    }
}
