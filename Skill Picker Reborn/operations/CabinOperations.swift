/*
 * CabinOperations.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2024 Ranger Lake Bible Camp
 *
 * Skill Picker Reborn is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Skill Picker Reborn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Skill Picker Reborn; if not, see <https://www.gnu.org/licenses/>.
 */

import Foundation

func createCabin(cabinName: String, targetSenior: Leader, targetJunior: Leader, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send();
    }
    //if leaders are already assigned to a cabin, replace their place in that cabin with the null leader
    if(targetSenior.cabin != "Unassigned"){
        data.c.cabins[targetSenior.cabin]!.senior = data.c.nullSenior
    }
    if(targetSenior != data.c.nullSenior){
        targetSenior.cabin = cabinName
    }
    if(targetJunior.cabin != "Unassigned"){
        data.c.cabins[targetJunior.cabin]!.junior = data.c.nullJunior
    }
    if(targetJunior != data.c.nullJunior){
        targetJunior.cabin = cabinName
    }
    data.c.cabins[cabinName] = try! Cabin(name: cabinName, senior: targetSenior, junior: targetJunior)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in createCabin")
        }
    }
}

func renameCabin(oldCabin: String, newCabin: String, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.cabins[newCabin] = data.c.cabins[oldCabin]
    data.c.cabins.removeValue(forKey: oldCabin)
    if(data.c.cabins[newCabin]!.senior != data.c.nullJunior){
        data.c.cabins[newCabin]!.senior.cabin = newCabin
    }
    if(data.c.cabins[newCabin]!.junior != data.c.nullJunior){
        data.c.cabins[newCabin]!.junior.cabin = newCabin
    }
    for camper in data.c.cabins[newCabin]!.campers {
        camper.cabin = newCabin
    }
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in renameCabin")
        }
    }
}

func deleteCabin(targetCabin: String, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    if(targetCabin == "Unassigned"){
        throw SPRError.RefusingDelete
    }
    for camper in data.c.campers.filter({$0.cabin == targetCabin}) {
        camper.cabin = "Unassigned"
    }
    for leader in data.c.leaders.filter({$0.cabin == targetCabin}) {
        leader.cabin = "Unassigned"
    }
    data.c.cabins.removeValue(forKey: targetCabin)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in deleteCabin")
        }
    }
}

func changeCabinLeaders(cabinName: String, targetSenior: Leader, targetJunior: Leader, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    //if the current cabin's leader is not the null leader, move them to the unassigned cabin
    if(data.c.cabins[cabinName]!.senior.id != data.c.nullSenior.id){
        data.c.cabins[cabinName]!.senior.cabin = "Unassigned"
    }
    if(data.c.cabins[cabinName]!.junior.id != data.c.nullJunior.id){
        data.c.cabins[cabinName]!.junior.cabin = "Unassigned"
    }
    data.c.cabins[targetSenior.cabin]!.senior = data.c.nullSenior
    data.c.cabins[cabinName]!.senior = targetSenior
    targetSenior.cabin = cabinName
    data.c.cabins[targetJunior.cabin]!.junior = data.c.nullJunior
    data.c.cabins[cabinName]!.junior = targetJunior
    targetJunior.cabin = cabinName
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in changeCabinLeaders")
        }
    }
}

func assignCamperToCabin(targetCamper: Camper, cabinName: String, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.cabins[targetCamper.cabin]!.campers.remove(targetCamper)
    targetCamper.cabin = cabinName
    data.c.cabins[cabinName]!.campers.insert(targetCamper)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in assignCamperToCabin")
        }
    }
}

func removeCamperFromCabin(camperID: Camper.ID, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.cabins[data.c.getCamper(camperID: camperID)!.cabin]!.campers.remove(data.c.getCamper(camperID: camperID)!)
    data.c.getCamper(camperID: camperID)!.cabin = "Unassigned"
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in removeCamperFromCabin")
        }
    }
}
