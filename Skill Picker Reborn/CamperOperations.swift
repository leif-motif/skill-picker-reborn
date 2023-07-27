//
//  CamperOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func newCamper(){
    
}

func deleteCamper(camperSelection: Set<Camper.ID>){
    for targetCamper in camperSelection {
        //remove camper from cabin
        fooCabins[fooCampers.first(where: {$0.id == targetCamper})!.cabin]!.campers.removeAll(where: {$0.id == targetCamper})
        //remove camper from skills
        if(fooCampers.first(where: {$0.id == targetCamper})!.skillOne != "None"){
            fooSkills[fooCampers.first(where: {$0.id == targetCamper})!.skillOne]!.periods[0].removeAll(where: {$0.id == targetCamper})
        }
        if(fooCampers.first(where: {$0.id == targetCamper})!.skillTwo != "None"){
            fooSkills[fooCampers.first(where: {$0.id == targetCamper})!.skillTwo]!.periods[1].removeAll(where: {$0.id == targetCamper})
        }
        if(fooCampers.first(where: {$0.id == targetCamper})!.skillThree != "None"){
            fooSkills[fooCampers.first(where: {$0.id == targetCamper})!.skillThree]!.periods[2].removeAll(where: {$0.id == targetCamper})
        }
        if(fooCampers.first(where: {$0.id == targetCamper})!.skillFour != "None"){
            fooSkills[fooCampers.first(where: {$0.id == targetCamper})!.skillFour]!.periods[3].removeAll(where: {$0.id == targetCamper})
        }
        //delete camper for good
        fooCampers.removeAll(where: {$0.id == targetCamper})
    }
}
