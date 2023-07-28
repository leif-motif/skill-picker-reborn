//
//  CamperOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createCamper(newCamper: Camper){
    fooCampers.append(newCamper)
    fooCabins[newCamper.cabin]!.campers.append(newCamper)
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
