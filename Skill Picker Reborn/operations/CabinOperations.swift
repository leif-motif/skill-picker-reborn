/*
 * CabinOperations.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2025 Ranger Lake Bible Camp
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

extension CampData {
    func createCabin(cabinName: String, targetSenior: Leader, targetJunior: Leader, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send();
        }
        //if leaders are already assigned to a cabin, replace their place in that cabin with the null leader
        if(targetSenior.cabin != "Unassigned"){
            self.c.cabins[targetSenior.cabin]!.senior = self.c.nullSenior
        }
        if(targetSenior != self.c.nullSenior){
            targetSenior.cabin = cabinName
        }
        if(targetJunior.cabin != "Unassigned"){
            self.c.cabins[targetJunior.cabin]!.junior = self.c.nullJunior
        }
        if(targetJunior != self.c.nullJunior){
            targetJunior.cabin = cabinName
        }
        self.c.cabins[cabinName] = try! Cabin(name: cabinName, senior: targetSenior, junior: targetJunior)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in createCabin")
            }
        }
    }
    
    func renameCabin(oldCabin: String, newCabin: String, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.cabins[newCabin] = self.c.cabins[oldCabin]
        self.c.cabins.removeValue(forKey: oldCabin)
        if(self.c.cabins[newCabin]!.senior != self.c.nullJunior){
            self.c.cabins[newCabin]!.senior.cabin = newCabin
        }
        if(self.c.cabins[newCabin]!.junior != self.c.nullJunior){
            self.c.cabins[newCabin]!.junior.cabin = newCabin
        }
        for camper in self.c.cabins[newCabin]!.campers {
            camper.cabin = newCabin
        }
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
#warning("TODO: implement undo in renameCabin")
            }
        }
    }
    
    func deleteCabin(targetCabin: String, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        if(targetCabin == "Unassigned"){
            throw SPRError.RefusingDelete
        }
        for camper in self.c.campers.filter({$0.cabin == targetCabin}) {
            camper.cabin = "Unassigned"
        }
        for leader in self.c.leaders.filter({$0.cabin == targetCabin}) {
            leader.cabin = "Unassigned"
        }
        self.c.cabins.removeValue(forKey: targetCabin)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in deleteCabin")
            }
        }
    }
    
    func changeCabinLeaders(cabinName: String, targetSenior: Leader, targetJunior: Leader, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        //if the current cabin's leader is not the null leader, move them to the unassigned cabin
        if(self.c.cabins[cabinName]!.senior.id != self.c.nullSenior.id){
            self.c.cabins[cabinName]!.senior.cabin = "Unassigned"
        }
        if(self.c.cabins[cabinName]!.junior.id != self.c.nullJunior.id){
            self.c.cabins[cabinName]!.junior.cabin = "Unassigned"
        }
        self.c.cabins[targetSenior.cabin]!.senior = self.c.nullSenior
        self.c.cabins[cabinName]!.senior = targetSenior
        targetSenior.cabin = cabinName
        self.c.cabins[targetJunior.cabin]!.junior = self.c.nullJunior
        self.c.cabins[cabinName]!.junior = targetJunior
        targetJunior.cabin = cabinName
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in changeCabinLeaders")
            }
        }
    }
    
    func assignCamperToCabin(targetCamper: Camper, cabinName: String, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.cabins[targetCamper.cabin]!.campers.remove(targetCamper)
        targetCamper.cabin = cabinName
        self.c.cabins[cabinName]!.campers.insert(targetCamper)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in assignCamperToCabin")
            }
        }
    }
    
    func removeCamperFromCabin(camperID: Camper.ID, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.cabins[self.getCamper(camperID: camperID)!.cabin]!.campers.remove(self.getCamper(camperID: camperID)!)
        self.getCamper(camperID: camperID)!.cabin = "Unassigned"
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in removeCamperFromCabin")
            }
        }
    }
}
