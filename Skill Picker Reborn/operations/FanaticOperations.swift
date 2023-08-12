/*
 * FanaticOperations.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2023 Ranger Lake Bible Camp
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
    
}

func changeFanaticPeriods(targetFanatic: String, newPeriods: [Bool], data: CampData){
    
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

