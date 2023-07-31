//
//  SkillOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createSkill(newSkill: Skill){
    skills[newSkill.name] = newSkill
}

func deleteSkill(skillName: String) throws {
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    for i in 0...3 {
        if(skills[skillName]!.maximums[i] != 0){
            for leader in skills[skillName]!.leaders[i] {
                leader.skills[i] = "None"
            }
            for camper in skills[skillName]!.periods[i] {
                camper.skills[i] = "None"
            }
        }
    }
    skills.removeValue(forKey: skillName)
}

func assignLeaderToSkill(targetLeader: Leader, skillName: String, period: Int){
    skills[skillName]!.leaders[period].append(targetLeader)
    targetLeader.skills[period] = skillName
}

func removeLeaderFromSkill(leaderSelection: Set<Leader.ID>, skillName: String, period: Int) throws {
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    for leaderID in leaderSelection {
        skills[skillName]!.leaders[period].removeAll(where: {$0.id == leaderID})
        leaders.first(where: {$0.id == leaderID})!.skills[period] = "None"
        skills["None"]!.leaders[period].append(leaders.first(where: {$0.id == leaderID})!)
    }
}

func assignCamperToSkill(targetCamper: Camper, skillName: String, period: Int) throws {
    if(skills[skillName]!.periods[period].count < skills[skillName]!.maximums[period]){
        skills[skillName]!.periods[period].append(targetCamper)
        targetCamper.skills[period] = skillName
    } else {
        throw SPRError.SkillFull
    }
}

func removeCamperFromSkill(camperSelection: Set<Camper.ID>, skillName: String, period: Int) throws {
    if(skillName == "None"){
        throw SPRError.RefusingDelete
    }
    for camperID in camperSelection {
        skills[skillName]!.periods[period].removeAll(where: {$0.id == camperID})
        campers.first(where: {$0.id == camperID})!.skills[period] = "None"
        skills["None"]!.periods[period].append(campers.first(where: {$0.id == camperID})!)
    }
}
