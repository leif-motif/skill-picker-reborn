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

func createFanatic(newFanatic: Fanatic, data: CampData){
    data.fanatics[newFanatic.name] = newFanatic
    data.skills[newFanatic.name] = try! Skill(name: newFanatic.name, maximums: [newFanatic.activePeriods[0] ? 255 : 0,
                                                                                newFanatic.activePeriods[1] ? 255 : 0,
                                                                                newFanatic.activePeriods[2] ? 255 : 0,
                                                                                newFanatic.activePeriods[3] ? 255 : 0])
}

func renameFanatic(oldName: String, newName: String, data: CampData) throws {
    for i in 0...3 {
        for camper in data.skills[oldName]!.periods[i] {
            if(camper.skills[i] == oldName){
                camper.skills[i] = newName
            }
            camper.fanatic = newName
        }
    }
    for i in 0...3 {
        for leader in data.skills[oldName]!.leaders[i] {
            if(leader.skills[i] == oldName){
                leader.skills[i] = newName
            }
        }
    }
    data.skills[newName] = data.skills[oldName]
    data.skills.removeValue(forKey: oldName)
    data.skills[newName]!.name = newName
    data.fanatics[newName] = data.fanatics[oldName]
    data.fanatics.removeValue(forKey: oldName)
    data.fanatics[newName]!.name = newName
}

func changeFanaticPeriods(targetFanatic: String, newPeriods: [Bool], data: CampData) throws {
    if(newPeriods.count != 4){
        throw SPRError.InvalidSize
    }
    var camperFanatics: [Camper]?
    var leaderFanatics: [Leader]?
    //find list of campers to use
    for i in 0...3 {
        if(data.fanatics[targetFanatic]!.activePeriods[i]){
            camperFanatics = data.skills[targetFanatic]!.periods[i]
            leaderFanatics = data.skills[targetFanatic]!.leaders[i]
        }
        break
    }
    for i in 0...3 {
        if(data.fanatics[targetFanatic]!.activePeriods[i] && !newPeriods[i]){
            for camper in data.skills[targetFanatic]!.periods[i] {
                camper.skills[i] = "None"
                data.skills["None"]!.periods[i].append(camper)
            }
            for leader in data.skills[targetFanatic]!.leaders[i] {
                leader.skills[i] = "None"
                data.skills["None"]!.leaders[i].append(leader)
            }
            data.skills[targetFanatic]!.periods[i] = []
            data.skills[targetFanatic]!.leaders[i] = []
            data.skills[targetFanatic]!.maximums[i] = 0
        } else if(!data.fanatics[targetFanatic]!.activePeriods[i] && newPeriods[i]){
            data.skills[targetFanatic]!.maximums[i] = 255
            for camper in camperFanatics! {
                if(camper.skills[i] != "None"){
                    try! removeCamperFromSkill(camperSelection: [camper.id], skillName: camper.skills[i], period: i, data: data)
                }
                assignCamperToSkill(targetCamper: camper, skillName: targetFanatic, period: i, data: data)
            }
            for leader in leaderFanatics! {
                if(leader.skills[i] != "None"){
                    try! removeLeaderFromSkill(leaderSelection: [leader.id], skillName: leader.skills[i], period: i, data: data)
                }
                assignLeaderToSkill(targetLeader: leader, skillName: targetFanatic, period: i, data: data)
            }
        }
    }
    data.fanatics[targetFanatic]!.activePeriods = newPeriods
}

func deleteFanatic(fanaticName: String, data: CampData) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    try! deleteSkill(skillName: fanaticName, data: data)
    data.fanatics.removeValue(forKey: fanaticName)
}

func assignLeaderToFanatic(targetLeader: Leader, fanaticName: String, data: CampData) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(data.fanatics[fanaticName]!.activePeriods[i]){
            data.skills[targetLeader.skills[i]]!.leaders[i].removeAll(where: {$0 == targetLeader})
            targetLeader.skills[i] = fanaticName
            data.skills[fanaticName]!.leaders[i].append(targetLeader)
        }
    }
}

func removeLeaderFromFanatic(leaderSelection: Set<Leader.ID>, fanaticName: String, data: CampData) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for leaderID in leaderSelection {
        for i in 0...3 {
            if(data.fanatics[fanaticName]!.activePeriods[i]){
                data.skills[fanaticName]!.leaders[i].removeAll(where: {$0.id == leaderID})
                data.leaders.first(where: {$0.id == leaderID})!.skills[i] = "None"
                data.skills["None"]!.leaders[i].append(data.leaders.first(where: {$0.id == leaderID})!)
            }
        }
    }
}

func assignCamperToFanatic(targetCamper: Camper, fanaticName: String, data: CampData) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(data.fanatics[fanaticName]!.activePeriods[i]){
            data.skills[targetCamper.skills[i]]!.periods[i].removeAll(where: {$0 == targetCamper})
            targetCamper.skills[i] = fanaticName
            data.skills[fanaticName]!.periods[i].append(targetCamper)
        }
    }
    targetCamper.fanatic = fanaticName
    targetCamper.preferredSkills.remove(at: 5)
}

func removeCamperFromFanatic(camperSelection: Set<Camper.ID>, fanaticName: String, newSixthPreferredSkill: String, data: CampData) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for camperID in camperSelection {
        for i in 0...3 {
            if(data.fanatics[fanaticName]!.activePeriods[i]){
                data.skills[fanaticName]!.periods[i].removeAll(where: {$0.id == camperID})
                data.campers.first(where: {$0.id == camperID})!.skills[i] = "None"
                data.skills["None"]!.periods[i].append(data.campers.first(where: {$0.id == camperID})!)
            }
        }
        data.campers.first(where: {$0.id == camperID})!.fanatic = "None"
        data.campers.first(where: {$0.id == camperID})!.preferredSkills.append(newSixthPreferredSkill)
    }
}

func evaluateFanatics(fanatic: String, periods: [String], data: CampData) throws -> Bool {
    //this returns true if the camper does not contain any fanatic skills it shouldn't have
    if(periods.count != 4){
        throw SPRError.InvalidSize
    }
    if(fanatic == "None"){
        return !periods.contains { key in
            data.fanatics.keys.contains(key)
        }
    } else {
        var valid = true
        for i in 0...3 {
            if(data.fanatics.keys.contains(periods[i]) && fanatic != periods[i] && !data.fanatics[fanatic]!.activePeriods[i]){
                valid = false
                break
            }
        }
        return valid
    }
}
