/*
 * CamperOperations.swift
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
import SwiftUI

extension CampData {
    func createCamper(newCamper: Camper, usingInternally: Bool = false) throws {
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.campers.insert(newCamper)
        self.c.cabins[newCamper.cabin]!.campers.insert(newCamper)
        //apply fanatic skills if it's passed
        if(newCamper.fanatic != "None"){
            for i in 0...3 {
                if(self.c.fanatics[newCamper.fanatic]!.activePeriods[i] && newCamper.skills[i] == "None"){
                    self.c.skills[newCamper.fanatic]!.periods[i].insert(newCamper)
                    newCamper.skills[i] = newCamper.fanatic
                } else if(self.c.fanatics[newCamper.fanatic]!.activePeriods[i]){
                    throw SPRError.SkillFanaticConflict
                } else {
                    self.c.skills[newCamper.skills[i]]!.periods[i].insert(newCamper)
                }
            }
        } else {
            for i in 0...3 {
                self.c.skills[newCamper.skills[i]]!.periods[i].insert(newCamper)
            }
        }
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in createCamper")
            }
        }
    }
    
    func deleteCamper(camperID: Camper.ID, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        //remove camper from cabin
        self.c.cabins[self.getCamper(camperID: camperID)!.cabin]!.campers.remove(self.getCamper(camperID: camperID)!)
        //remove camper from skills
        for i in 0...3 {
            self.c.skills[self.getCamper(camperID: camperID)!.skills[i]]!.periods[i].remove(self.getCamper(camperID: camperID)!)
        }
        //delete camper for good
        self.c.campers.remove(self.getCamper(camperID: camperID)!)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in deleteCamper")
            }
        }
    }
}

func prefSkillPercentage(targetCamper: Camper) -> Text {
    var topFour: [String] = Array(targetCamper.preferredSkills[0...3])
    topFour.removeAll(where: {$0 == "None"})
    var nonFanatics = targetCamper.skills
    nonFanatics.removeAll(where: {$0 == targetCamper.fanatic})
    let set1 = Set(nonFanatics)
    let set2 = Set(topFour)
    let intersection = set1.intersection(set2)
    
    var percentage = Double(intersection.count) / Double(set1.count)
    if(percentage.isNaN){
        percentage = 0
    }
    let fmt = NumberFormatter()
    fmt.numberStyle = .percent
    fmt.minimumIntegerDigits = 1
    fmt.maximumIntegerDigits = 3
    fmt.minimumFractionDigits = 0
    fmt.maximumFractionDigits = 0
    if(percentage != 1){
        return Text(fmt.string(from: NSNumber(value: percentage))!).foregroundColor(Color(percentage == 0 ? .systemRed : .systemYellow))
    }
    return Text("100%").foregroundColor(Color(.systemGreen))
}
