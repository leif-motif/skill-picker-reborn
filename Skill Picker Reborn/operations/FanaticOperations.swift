//
//  FanaticOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-28.
//

import Foundation

func createFanatic(newFanatic: Fanatic){
    fanatics[newFanatic.name] = newFanatic
    skills[newFanatic.name] = try! Skill(name: newFanatic.name, maximums: [newFanatic.activePeriods[0] ? 255 : 0,
                                                                           newFanatic.activePeriods[1] ? 255 : 0,
                                                                           newFanatic.activePeriods[2] ? 255 : 0,
                                                                           newFanatic.activePeriods[3] ? 255 : 0])
}

func deleteFanatic(fanaticName: String) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    try! deleteSkill(skillName: fanaticName)
    fanatics.removeValue(forKey: fanaticName)
}

func assignLeaderToFanatic(targetLeader: Leader, fanaticName: String) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(fanatics[fanaticName]!.activePeriods[i]){
            targetLeader.skills[i] = fanaticName
            skills[fanaticName]!.leaders[i].append(targetLeader)
        }
    }
}

func removeLeaderFromFanatic(leaderSelection: Set<Leader.ID>, fanaticName: String) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for leaderID in leaderSelection {
        for i in 0...3 {
            if(fanatics[fanaticName]!.activePeriods[i]){
                skills[fanaticName]!.leaders[i].removeAll(where: {$0.id == leaderID})
                leaders.first(where: {$0.id == leaderID})!.skills[i] = "None"
                skills["None"]!.leaders[i].append(leaders.first(where: {$0.id == leaderID})!)
            }
        }
    }
}

func assignCamperToFanatic(targetCamper: Camper, fanaticName: String) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for i in 0...3 {
        if(fanatics[fanaticName]!.activePeriods[i]){
            targetCamper.skills[i] = fanaticName
            skills[fanaticName]!.periods[i].append(targetCamper)
        }
    }
    targetCamper.fanatic = fanaticName
    targetCamper.preferredSkills.remove(at: 5)
}

func removeCamperFromFanatic(camperSelection: Set<Camper.ID>, fanaticName: String, newSixthPreferredSkill: String) throws {
    if(fanaticName == "None"){
        throw SPRError.NoneSkillRefusal
    }
    for camperID in camperSelection {
        for i in 0...3 {
            if(fanatics[fanaticName]!.activePeriods[i]){
                skills[fanaticName]!.periods[i].removeAll(where: {$0.id == camperID})
                campers.first(where: {$0.id == camperID})!.skills[i] = "None"
                skills["None"]!.periods[i].append(campers.first(where: {$0.id == camperID})!)
            }
        }
        campers.first(where: {$0.id == camperID})!.fanatic = "None"
        campers.first(where: {$0.id == camperID})!.preferredSkills.append(newSixthPreferredSkill)
    }
}

