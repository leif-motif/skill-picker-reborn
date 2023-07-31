//
//  FanaticOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-28.
//

import Foundation

func createFanatic(newFanatic: Fanatic){
    fooFanatics[newFanatic.name] = newFanatic
    fooSkills[newFanatic.name] = try! Skill(name: newFanatic.name, maximums: [newFanatic.activePeriods[0] ? 255 : 0,
                                                                              newFanatic.activePeriods[1] ? 255 : 0,
                                                                              newFanatic.activePeriods[2] ? 255 : 0,
                                                                              newFanatic.activePeriods[3] ? 255 : 0])
}

func deleteFanatic(fanaticName: String) throws {
    try deleteSkill(skillName: fanaticName)
    fooFanatics.removeValue(forKey: fanaticName)
}

func assignLeaderToFanatic(targetLeader: Leader, fanaticName: String){
    if(fooFanatics[fanaticName]!.activePeriods[0]){
        targetLeader.skillOne = fanaticName
        fooSkills[fanaticName]!.leaders[0].append(targetLeader)
    }
    if(fooFanatics[fanaticName]!.activePeriods[1]){
        targetLeader.skillTwo = fanaticName
        fooSkills[fanaticName]!.leaders[1].append(targetLeader)
    }
    if(fooFanatics[fanaticName]!.activePeriods[2]){
        targetLeader.skillThree = fanaticName
        fooSkills[fanaticName]!.leaders[2].append(targetLeader)
    }
    if(fooFanatics[fanaticName]!.activePeriods[3]){
        targetLeader.skillFour = fanaticName
        fooSkills[fanaticName]!.leaders[3].append(targetLeader)
    }
}

func removeLeaderFromFanatic(leaderSelection: Set<Leader.ID>, fanaticName: String){
    
}

func assignCamperToFanatic(targetCamper: Camper, fanaticName: String){
    if(fooFanatics[fanaticName]!.activePeriods[0]){
        targetCamper.skillOne = fanaticName
        fooSkills[fanaticName]!.periods[0].append(targetCamper)
    }
    if(fooFanatics[fanaticName]!.activePeriods[1]){
        targetCamper.skillTwo = fanaticName
        fooSkills[fanaticName]!.periods[1].append(targetCamper)
    }
    if(fooFanatics[fanaticName]!.activePeriods[2]){
        targetCamper.skillThree = fanaticName
        fooSkills[fanaticName]!.periods[2].append(targetCamper)
    }
    if(fooFanatics[fanaticName]!.activePeriods[3]){
        targetCamper.skillFour = fanaticName
        fooSkills[fanaticName]!.periods[3].append(targetCamper)
    }
}

func removeCamperFromFanatic(camperSelection: Set<Camper.ID>){
    
}

