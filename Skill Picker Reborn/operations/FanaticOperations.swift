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
    try! deleteSkill(skillName: fanaticName)
    fanatics.removeValue(forKey: fanaticName)
}

func assignLeaderToFanatic(targetLeader: Leader, fanaticName: String){
    for i in 0...3 {
        if(fanatics[fanaticName]!.activePeriods[i]){
            targetLeader.skills[i] = fanaticName
            skills[fanaticName]!.leaders[i].append(targetLeader)
        }
    }
}

func removeLeaderFromFanatic(leaderSelection: Set<Leader.ID>, fanaticName: String){
    
}

func assignCamperToFanatic(targetCamper: Camper, fanaticName: String){
    for i in 0...3 {
        if(fanatics[fanaticName]!.activePeriods[i]){
            targetCamper.skills[i] = fanaticName
            skills[fanaticName]!.periods[i].append(targetCamper)
        }
    }
}

func removeCamperFromFanatic(camperSelection: Set<Camper.ID>){
    
}

