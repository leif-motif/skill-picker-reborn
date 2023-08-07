//
//  SkillOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createSkill(newSkill: Skill, data: CampData){
    data.skills[newSkill.name] = newSkill
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

func assignCamperToSkill(targetCamper: Camper, skillName: String, period: Int, data: CampData) throws {
    if(data.skills[skillName]!.periods[period].count < data.skills[skillName]!.maximums[period]){
        data.skills[targetCamper.skills[period]]!.periods[period].removeAll(where: {$0 == targetCamper})
        data.skills[skillName]!.periods[period].append(targetCamper)
        targetCamper.skills[period] = skillName
    } else {
        throw SPRError.SkillFull
    }
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
    for p in 0...3 {
        for camper in data.campers {
            if(camper.skills[p] == "None"){
                //first pass: try to assign a preferred skill
                for prefSkill in camper.preferredSkills {
                    if(prefSkill != "None" && data.skills[prefSkill]!.maximums[p] > data.skills[prefSkill]!.periods[p].count && !camper.skills.contains(prefSkill)){
                        try! assignCamperToSkill(targetCamper: camper, skillName: prefSkill, period: p, data: data)
                        break
                    } else if(prefSkill == "None"){
                        for availableSkill in Array(data.skills.keys).filter({!data.fanatics.keys.contains($0)}){
                            if(availableSkill != "None" && data.skills[availableSkill]!.maximums[p] > data.skills[availableSkill]!.periods[p].count && !camper.skills.contains(availableSkill)){
                                try! assignCamperToSkill(targetCamper: camper, skillName: availableSkill, period: p, data: data)
                                break
                            }
                        }
                    }
                }
                //second pass: try to assign an available skill
                if(camper.skills[p] == "None"){
                    for availableSkill in Array(data.skills.keys).filter({!data.fanatics.keys.contains($0)}){
                        if(availableSkill != "None" && data.skills[availableSkill]!.maximums[p] > data.skills[availableSkill]!.periods[p].count && !camper.skills.contains(availableSkill)){
                            try! assignCamperToSkill(targetCamper: camper, skillName: availableSkill, period: p, data: data)
                            break
                        }
                    }
                    //third pass: crash
                    if(camper.skills[p] == "None"){
                        throw SPRError.CamperCouldNotGetSkill
                    }
                }
            }
        }
    }
}
