//
//  CamperOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createCamper(newCamper: Camper) throws {
    fooCampers.append(newCamper)
    fooCabins[newCamper.cabin]!.campers.append(newCamper)
    //apply fanatic skills if it's passed
    if(newCamper.fanatic != "None"){
        for i in 0...3 {
            if(fooFanatics[newCamper.fanatic]!.activePeriods[i] && newCamper.skills[i] == "None"){
                fooSkills[newCamper.fanatic]!.periods[i].append(newCamper)
                newCamper.skills[i] = newCamper.fanatic
            } else if(fooFanatics[newCamper.fanatic]!.activePeriods[i]){
                throw SPRError.SkillFanaticConflict
            } else {
                fooSkills[newCamper.skills[i]]!.periods[i].append(newCamper)
            }
        }
    } else {
        for i in 0...3 {
            fooSkills[newCamper.skills[i]]!.periods[i].append(newCamper)
        }
    }
}

func deleteCamper(camperSelection: Set<Camper.ID>){
    for camperID in camperSelection {
        //remove camper from cabin
        fooCabins[fooCampers.first(where: {$0.id == camperID})!.cabin]!.campers.removeAll(where: {$0.id == camperID})
        //remove camper from skills
        for i in 0...3 {
            if(fooCampers.first(where: {$0.id == camperID})!.skills[i] != "None"){
                fooSkills[fooCampers.first(where: {$0.id == camperID})!.skills[i]]!.periods[i].removeAll(where: {$0.id == camperID})
            }
        }
        //delete camper for good
        fooCampers.removeAll(where: {$0.id == camperID})
    }
}
