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

func createCamper(newCamper: Camper, data: CampData, usingInternally: Bool = false) throws {
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.campers.append(newCamper)
    data.c.cabins[newCamper.cabin]!.campers.append(newCamper)
    //apply fanatic skills if it's passed
    if(newCamper.fanatic != "None"){
        for i in 0...3 {
            if(data.c.fanatics[newCamper.fanatic]!.activePeriods[i] && newCamper.skills[i] == "None"){
                data.c.skills[newCamper.fanatic]!.periods[i].append(newCamper)
                newCamper.skills[i] = newCamper.fanatic
            } else if(data.c.fanatics[newCamper.fanatic]!.activePeriods[i]){
                throw SPRError.SkillFanaticConflict
            } else {
                data.c.skills[newCamper.skills[i]]!.periods[i].append(newCamper)
            }
        }
    } else {
        for i in 0...3 {
            data.c.skills[newCamper.skills[i]]!.periods[i].append(newCamper)
        }
    }
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in createCamper")
        }
    }
}

func deleteCamper(camperID: Camper.ID, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    //remove camper from cabin
    data.c.cabins[data.c.campers.first(where: {$0.id == camperID})!.cabin]!.campers.removeAll(where: {$0.id == camperID})
    //remove camper from skills
    for i in 0...3 {
        data.c.skills[data.c.campers.first(where: {$0.id == camperID})!.skills[i]]!.periods[i].removeAll(where: {$0.id == camperID})
    }
    //delete camper for good
    data.c.campers.removeAll(where: {$0.id == camperID})
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in deleteCamper")
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
