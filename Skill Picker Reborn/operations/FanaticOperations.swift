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
    
}

func removeLeaderFromFanatic(leaderSelection: Set<Leader.ID>, fanaticName: String){
    
}

func assignCamperToFanatic(targetCamper: Camper, fanaticName: String){
    
}

func removeCamperFromFanatic(camperSelection: Set<Camper.ID>){
    
}

