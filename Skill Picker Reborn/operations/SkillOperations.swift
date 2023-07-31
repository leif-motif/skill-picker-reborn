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
    for i in 0...3 {
        if(fooSkills[skillName]!.maximums[i] != 0){
            for leader in fooSkills[skillName]!.leaders[i] {
                leader.skills[i] = "None"
            }
            for camper in fooSkills[skillName]!.periods[i] {
                camper.skills[i] = "None"
            }
        }
    }
    fooSkills.removeValue(forKey: skillName)
}

func assignLeaderToSkill(targetLeader: Leader, skillName: String, period: Int){
    fooSkills[skillName]!.leaders[period].append(targetLeader)
    targetLeader.skills[period] = skillName
}

func removeLeaderFromSkill(leaderSelection: Set<Leader.ID>, skillName: String, period: Int){
    
}

func assignCamperToSkill(targetCamper: Camper, skillName: String, period: Int) throws {
    if(fooSkills[skillName]!.periods[period].count < fooSkills[skillName]!.maximums[period]){
        fooSkills[skillName]!.periods[period].append(targetCamper)
        targetCamper.skills[period] = skillName
    } else {
        throw SPRError.SkillFull
    }
}

func removeCamperFromSkill(camperSelection: Set<Camper.ID>, skillName: String, period: Int){
    
}
