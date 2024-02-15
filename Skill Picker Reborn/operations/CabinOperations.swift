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

func createCabin(cabinName: String, targetSenior: Leader, targetJunior: Leader, data: CampData){
    //if leaders are already assigned to a cabin, replace their place in that cabin with the null leader
    if(targetSenior.cabin != "Unassigned"){
        data.cabins[targetSenior.cabin]!.senior = data.nullSenior
    }
    if(targetSenior != data.nullSenior){
        targetSenior.cabin = cabinName
    }
    if(targetJunior.cabin != "Unassigned"){
        data.cabins[targetJunior.cabin]!.junior = data.nullJunior
    }
    if(targetJunior != data.nullJunior){
        targetJunior.cabin = cabinName
    }
    data.cabins[cabinName] = try! Cabin(name: cabinName, senior: targetSenior, junior: targetJunior)
}

func renameCabin(oldCabin: String, newCabin: String, data: CampData){
    data.cabins[newCabin] = data.cabins[oldCabin]
    data.cabins.removeValue(forKey: oldCabin)
    if(data.cabins[newCabin]!.senior != data.nullJunior){
        data.cabins[newCabin]!.senior.cabin = newCabin
    }
    if(data.cabins[newCabin]!.junior != data.nullJunior){
        data.cabins[newCabin]!.junior.cabin = newCabin
    }
    for camper in data.cabins[newCabin]!.campers {
        camper.cabin = newCabin
    }
}

func deleteCabin(targetCabin: String, data: CampData) throws {
    if(targetCabin == "Unassigned"){
        throw SPRError.RefusingDelete
    }
    for camper in data.campers.filter({$0.cabin == targetCabin}) {
        camper.cabin = "Unassigned"
    }
    for leader in data.leaders.filter({$0.cabin == targetCabin}) {
        leader.cabin = "Unassigned"
    }
    data.cabins.removeValue(forKey: targetCabin)
}

func changeCabinLeaders(cabinName: String, targetSenior: Leader, targetJunior: Leader, data: CampData){
    //if the current cabin's leader is not the null leader, move them to the unassigned cabin
    if(data.cabins[cabinName]!.senior.id != data.nullSenior.id){
        data.cabins[cabinName]!.senior.cabin = "Unassigned"
    }
    if(data.cabins[cabinName]!.junior.id != data.nullJunior.id){
        data.cabins[cabinName]!.junior.cabin = "Unassigned"
    }
    data.cabins[targetSenior.cabin]!.senior = data.nullSenior
    data.cabins[cabinName]!.senior = targetSenior
    targetSenior.cabin = cabinName
    data.cabins[targetJunior.cabin]!.junior = data.nullJunior
    data.cabins[cabinName]!.junior = targetJunior
    targetJunior.cabin = cabinName
}

func assignCamperToCabin(targetCamper: Camper, cabinName: String, data: CampData){
    data.cabins[targetCamper.cabin]!.campers.removeAll(where: {$0 == targetCamper})
    targetCamper.cabin = cabinName
    data.cabins[cabinName]!.campers.append(targetCamper)
}

func removeCamperFromCabin(camperSelection: Set<Camper.ID>, data: CampData){
    for targetCamper in camperSelection {
        data.cabins[data.campers.first(where: {$0.id == targetCamper})!.cabin]!.campers.removeAll(where: {$0.id == targetCamper})
        data.campers.first(where: {$0.id == targetCamper})!.cabin = "Unassigned"
    }
}
