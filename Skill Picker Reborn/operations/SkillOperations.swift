/*
 * SkillOperations.swift
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

func createSkill(newSkill: Skill, data: CampData){
    data.skills[newSkill.name] = newSkill
}

func renameSkill(oldName: String, newName: String, data: CampData) throws {
    if(oldName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    if(data.skills.keys.contains(newName)){
        throw SPRError.DuplicateSkillName
    }
    for camper in data.campers {
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
    data.skills[newName] = data.skills[oldName]
    data.skills.removeValue(forKey: oldName)
    data.skills[newName]!.name = newName
    for i in 0...3 {
        for leader in data.skills[newName]!.leaders[i] {
            leader.skills[i] = newName
        }
    }
}

func deleteSkill(skillName: String, data: CampData) throws {
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    for i in 0...3 {
        if(data.skills[skillName]!.maximums[i] != 0){
            for leader in data.skills[skillName]!.leaders[i] {
                leader.skills[i] = "None"
            }
            for camper in data.skills[skillName]!.periods[i] {
                camper.skills[i] = "None"
            }
        }
    }
    for camper in data.campers {
        for i in 0...(camper.preferredSkills.count-1){
            if(camper.preferredSkills[i] == skillName){
                camper.preferredSkills.remove(at: i)
                camper.preferredSkills.append("None")
            }
        }
    }
    data.skills.removeValue(forKey: skillName)
}

func assignLeaderToSkill(targetLeader: Leader, skillName: String, period: Int, data: CampData){
    data.skills[targetLeader.skills[period]]!.leaders[period].removeAll(where: {$0 == targetLeader})
    data.skills[skillName]!.leaders[period].append(targetLeader)
    targetLeader.skills[period] = skillName
}

func removeLeaderFromSkill(leaderSelection: Set<Leader.ID>, skillName: String, period: Int, data: CampData) throws {
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    for leaderID in leaderSelection {
        data.skills[skillName]!.leaders[period].removeAll(where: {$0.id == leaderID})
        data.leaders.first(where: {$0.id == leaderID})!.skills[period] = "None"
        data.skills["None"]!.leaders[period].append(data.leaders.first(where: {$0.id == leaderID})!)
    }
}

func assignCamperToSkill(targetCamper: Camper, skillName: String, period: Int, data: CampData){
    data.skills[targetCamper.skills[period]]!.periods[period].removeAll(where: {$0 == targetCamper})
    data.skills[skillName]!.periods[period].append(targetCamper)
    targetCamper.skills[period] = skillName
}

func removeCamperFromSkill(camperSelection: Set<Camper.ID>, skillName: String, period: Int, data: CampData) throws {
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    for camperID in camperSelection {
        data.skills[skillName]!.periods[period].removeAll(where: {$0.id == camperID})
        data.campers.first(where: {$0.id == camperID})!.skills[period] = "None"
        data.skills["None"]!.periods[period].append(data.campers.first(where: {$0.id == camperID})!)
    }
}

func clearAllCamperSkills(data: CampData){
    for skill in data.skills.keys {
        if(!data.fanatics.keys.contains(skill)){
            for i in 0...3 {
                for camper in data.skills[skill]!.periods[i] {
                    camper.skills[i] = "None"
                }
                data.skills[skill]!.periods[i] = []
            }
        }
    }
}

func processPreferredSkills(data: CampData) throws {
    if(data.skills.count == 1){
        throw SPRError.NoSkills
    }
    var emptySpaces: Int
    for p in 0...3 {
        emptySpaces = 0
        for skill in data.skills.keys {
            if(skill != "None" && !data.fanatics.keys.contains(skill)){
                emptySpaces += data.skills[skill]!.maximums[p]-data.skills[skill]!.periods[p].count
            }
        }
        if(emptySpaces-data.skills["None"]!.periods[p].count < 0){
            throw SPRError.NotEnoughSkillSpace
        }
    }
    for p in 0...5 {
        for camper in data.campers {
            if(camper.skills.contains("None") && (camper.fanatic == "None" || p != 5)){
                if(camper.preferredSkills[p] != "None"){
                    var skillCaps: [Int?] = [nil,nil,nil,nil]
                    for i in 0...3 {
                        if(camper.skills[i] == "None" && data.skills[camper.preferredSkills[p]]!.maximums[i] > data.skills[camper.preferredSkills[p]]!.periods[i].count){
                            skillCaps[i] = data.skills[camper.preferredSkills[p]]!.periods[i].count
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
                        assignCamperToSkill(targetCamper: camper, skillName: camper.preferredSkills[p], period: highestCountIndexes[Int.random(in: 0..<highestCountIndexes.count)], data: data)
                    }
                }
            }
        }
    }
}
