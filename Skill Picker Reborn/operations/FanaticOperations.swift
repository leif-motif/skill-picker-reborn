//
//  FanaticOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-28.
//

import Foundation

func createFanatic(newFanatic: Fanatic, data: CampData){
    data.fanatics[newFanatic.name] = newFanatic
    data.skills[newFanatic.name] = try! Skill(name: newFanatic.name, maximums: [newFanatic.activePeriods[0] ? 255 : 0,
                                                                                newFanatic.activePeriods[1] ? 255 : 0,
                                                                                newFanatic.activePeriods[2] ? 255 : 0,
                                                                                newFanatic.activePeriods[3] ? 255 : 0])
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
            data.skills[targetCamper.skills[i]]!.leaders[i].removeAll(where: {$0 == targetCamper})
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

