//
//  CamperOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createCamper(newCamper: Camper) throws {
    campers.append(newCamper)
    cabins[newCamper.cabin]!.campers.append(newCamper)
    //apply fanatic skills if it's passed
    if(newCamper.fanatic != "None"){
        for i in 0...3 {
            if(fanatics[newCamper.fanatic]!.activePeriods[i] && newCamper.skills[i] == "None"){
                skills[newCamper.fanatic]!.periods[i].append(newCamper)
                newCamper.skills[i] = newCamper.fanatic
            } else if(fanatics[newCamper.fanatic]!.activePeriods[i]){
                throw SPRError.SkillFanaticConflict
            } else {
                skills[newCamper.skills[i]]!.periods[i].append(newCamper)
            }
        }
    } else {
        for i in 0...3 {
            skills[newCamper.skills[i]]!.periods[i].append(newCamper)
        }
    }
}

func deleteCamper(camperSelection: Set<Camper.ID>){
    for camperID in camperSelection {
        //remove camper from cabin
        cabins[campers.first(where: {$0.id == camperID})!.cabin]!.campers.removeAll(where: {$0.id == camperID})
        //remove camper from skills
        for i in 0...3 {
            skills[campers.first(where: {$0.id == camperID})!.skills[i]]!.periods[i].removeAll(where: {$0.id == camperID})
        }
        //delete camper for good
        campers.removeAll(where: {$0.id == camperID})
    }
}
