//
//  CabinOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createCabin(cabinName: String, targetSenior: Leader, targetJunior: Leader){
    //IF THERE ARE REFERENCE ERRORS, LOOK HERE FOR WHERE EVERYTHING WENT WRONG.
    
    //if leaders are already assigned to a cabin, replace their place in that cabin with the null leader
    if(targetSenior.cabin != "Unassigned"){
        cabins[targetSenior.cabin]!.senior = nullSenior
    }
    targetSenior.cabin = cabinName
    if(targetJunior.cabin != "Unassigned"){
        cabins[targetJunior.cabin]!.junior = nullJunior
    }
    targetJunior.cabin = cabinName
    cabins[cabinName] = try! Cabin(name: cabinName, senior: targetSenior, junior: targetJunior)
}

func deleteCabin(targetCabin: String) throws {
    if(targetCabin == "Unassigned"){
        throw SPRError.RefusingDelete
    }
    for camper in campers.filter({$0.cabin == targetCabin}) {
        camper.cabin = "Unassigned"
    }
    for leader in leaders.filter({$0.cabin == targetCabin}) {
        leader.cabin = "Unassigned"
    }
    cabins.removeValue(forKey: targetCabin)
}

func changeCabinLeaders(cabinName: String, targetSenior: Leader, targetJunior: Leader){
    //if the current cabin's leader is not the null leader, move them to the unassigned cabin
    if(cabins[cabinName]!.senior.id != nullSenior.id){
        cabins[cabinName]!.senior.cabin = "Unassigned"
    }
    if(cabins[cabinName]!.junior.id != nullJunior.id){
        cabins[cabinName]!.junior.cabin = "Unassigned"
    }
    cabins[cabinName]!.senior = targetSenior
    targetSenior.cabin = cabinName
    cabins[cabinName]!.junior = targetJunior
    targetJunior.cabin = cabinName
}

func assignCamperToCabin(targetCamper: Camper, cabinName: String){
    
}

func removeCamperFromCabin(camperSelection: Set<Camper.ID>){
    for targetCamper in camperSelection {
        cabins[campers.first(where: {$0.id == targetCamper})!.cabin]!.campers.removeAll(where: {$0.id == targetCamper})
        campers.first(where: {$0.id == targetCamper})!.cabin = "Unassigned"
    }
}
