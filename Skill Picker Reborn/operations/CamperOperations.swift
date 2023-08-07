//
//  CamperOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createCamper(newCamper: Camper, data: CampData) throws {
    data.campers.append(newCamper)
    data.cabins[newCamper.cabin]!.campers.append(newCamper)
    //apply fanatic skills if it's passed
    if(newCamper.fanatic != "None"){
        for i in 0...3 {
            if(data.fanatics[newCamper.fanatic]!.activePeriods[i] && newCamper.skills[i] == "None"){
                data.skills[newCamper.fanatic]!.periods[i].append(newCamper)
                newCamper.skills[i] = newCamper.fanatic
            } else if(data.fanatics[newCamper.fanatic]!.activePeriods[i]){
                throw SPRError.SkillFanaticConflict
            } else {
                data.skills[newCamper.skills[i]]!.periods[i].append(newCamper)
            }
        }
    } else {
        for i in 0...3 {
            data.skills[newCamper.skills[i]]!.periods[i].append(newCamper)
        }
    }
}

func deleteCamper(camperSelection: Set<Camper.ID>, data: CampData){
    for camperID in camperSelection {
        //remove camper from cabin
        data.cabins[data.campers.first(where: {$0.id == camperID})!.cabin]!.campers.removeAll(where: {$0.id == camperID})
        //remove camper from skills
        for i in 0...3 {
            data.skills[data.campers.first(where: {$0.id == camperID})!.skills[i]]!.periods[i].removeAll(where: {$0.id == camperID})
        }
        //delete camper for good
        data.campers.removeAll(where: {$0.id == camperID})
    }
}
