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
        if(fooFanatics[newCamper.fanatic]!.activePeriods[0] && newCamper.skillOne == "None"){
            fooSkills[newCamper.fanatic]!.periods[0].append(newCamper)
            newCamper.skillOne = newCamper.fanatic
        } else if(fooFanatics[newCamper.fanatic]!.activePeriods[0]){
            throw ValueError.SkillFanaticConflict
        } else {
            fooSkills[newCamper.skillOne]!.periods[0].append(newCamper)
        }
        if(fooFanatics[newCamper.fanatic]!.activePeriods[1] && newCamper.skillTwo == "None"){
            fooSkills[newCamper.fanatic]!.periods[1].append(newCamper)
            newCamper.skillTwo = newCamper.fanatic
        } else if(fooFanatics[newCamper.fanatic]!.activePeriods[1]){
            throw ValueError.SkillFanaticConflict
        } else {
            fooSkills[newCamper.skillTwo]!.periods[1].append(newCamper)
        }
        if(fooFanatics[newCamper.fanatic]!.activePeriods[2] && newCamper.skillThree == "None"){
            fooSkills[newCamper.fanatic]!.periods[2].append(newCamper)
            newCamper.skillThree = newCamper.fanatic
        } else if(fooFanatics[newCamper.fanatic]!.activePeriods[2]){
            throw ValueError.SkillFanaticConflict
        } else {
            fooSkills[newCamper.skillThree]!.periods[2].append(newCamper)
        }
        if(fooFanatics[newCamper.fanatic]!.activePeriods[3] && newCamper.skillFour == "None"){
            fooSkills[newCamper.fanatic]!.periods[3].append(newCamper)
            newCamper.skillFour = newCamper.fanatic
        } else if(fooFanatics[newCamper.fanatic]!.activePeriods[3]){
            throw ValueError.SkillFanaticConflict
        } else {
            fooSkills[newCamper.skillFour]!.periods[3].append(newCamper)
        }
    } else {
        fooSkills[newCamper.skillOne]!.periods[0].append(newCamper)
        fooSkills[newCamper.skillTwo]!.periods[1].append(newCamper)
        fooSkills[newCamper.skillThree]!.periods[2].append(newCamper)
        fooSkills[newCamper.skillFour]!.periods[3].append(newCamper)
    }
}

func deleteCamper(camperSelection: Set<Camper.ID>){
    for camperID in camperSelection {
        //remove camper from cabin
        fooCabins[fooCampers.first(where: {$0.id == camperID})!.cabin]!.campers.removeAll(where: {$0.id == camperID})
        //remove camper from skills
        if(fooCampers.first(where: {$0.id == camperID})!.skillOne != "None"){
            fooSkills[fooCampers.first(where: {$0.id == camperID})!.skillOne]!.periods[0].removeAll(where: {$0.id == camperID})
        }
        if(fooCampers.first(where: {$0.id == camperID})!.skillTwo != "None"){
            fooSkills[fooCampers.first(where: {$0.id == camperID})!.skillTwo]!.periods[1].removeAll(where: {$0.id == camperID})
        }
        if(fooCampers.first(where: {$0.id == camperID})!.skillThree != "None"){
            fooSkills[fooCampers.first(where: {$0.id == camperID})!.skillThree]!.periods[2].removeAll(where: {$0.id == camperID})
        }
        if(fooCampers.first(where: {$0.id == camperID})!.skillFour != "None"){
            fooSkills[fooCampers.first(where: {$0.id == camperID})!.skillFour]!.periods[3].removeAll(where: {$0.id == camperID})
        }
        //delete camper for good
        fooCampers.removeAll(where: {$0.id == camperID})
    }
}
