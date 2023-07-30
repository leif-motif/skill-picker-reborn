//
//  SkillOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createSkill(newSkill: Skill){
    fooSkills[newSkill.name] = newSkill
    
}

func deleteSkill(skillName: String) throws {
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    if(fooSkills[skillName]!.maximums[0] != 0){
        for leader in fooSkills[skillName]!.leaders[0] {
            leader.skillOne = "None"
        }
        for camper in fooSkills[skillName]!.periods[0] {
            camper.skillOne = "None"
        }
    }
    if(fooSkills[skillName]!.maximums[1] != 0){
        for leader in fooSkills[skillName]!.leaders[1] {
            leader.skillTwo = "None"
        }
        for camper in fooSkills[skillName]!.periods[1] {
            camper.skillTwo = "None"
        }
    }
    if(fooSkills[skillName]!.maximums[2] != 0){
        for leader in fooSkills[skillName]!.leaders[2] {
            leader.skillThree = "None"
        }
        for camper in fooSkills[skillName]!.periods[2] {
            camper.skillThree = "None"
        }
    }
    if(fooSkills[skillName]!.maximums[3] != 0){
        for leader in fooSkills[skillName]!.leaders[3] {
            leader.skillFour = "None"
        }
        for camper in fooSkills[skillName]!.periods[3] {
            camper.skillFour = "None"
        }
    }
    fooSkills.removeValue(forKey: skillName)
}

func assignLeaderToSkill(targetLeader: Leader, skillName: String, period: Int){
    
}

func removeLeaderFromSkill(leaderSelection: Set<Leader.ID>, skillName: String, period: Int){
    
}

func assignCamperToSkill(targetCamper: Camper, skillName: String, period: Int){
    
}

func removeCamperFromSkill(camperSelection: Set<Camper.ID>, skillName: String, period: Int){
    
}
