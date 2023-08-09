/*
 * CamperOperations.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2023 Ranger Lake Bible Camp
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

func createCamper(newCamper: Camper, data: CampData) throws {
    data.campers.append(newCamper)
    data.cabins[newCamper.cabin]!.campers.append(newCamper)
    //apply fanatic skills if it's passed
    if(newCamper.fanatic != "None"){
        for i in 0...3 {
            if(data.fanatics[newCamper.fanatic]!.activePeriods[i] && newCamper.skills[i] == "None"){
                data.skills[newCamper.fanatic]!.periods[i].append(newCamper)
                newCamper.skills[i] = newCamper.fanatic
            } else if(data.fanatics[newCamper.fanatic]!.activePeriods[i]){
                throw SPRError.SkillFanaticConflict
            } else {
                data.skills[newCamper.skills[i]]!.periods[i].append(newCamper)
            }
        }
    } else {
        for i in 0...3 {
            data.skills[newCamper.skills[i]]!.periods[i].append(newCamper)
        }
    }
}

func deleteCamper(camperSelection: Set<Camper.ID>, data: CampData){
    for camperID in camperSelection {
        //remove camper from cabin
        data.cabins[data.campers.first(where: {$0.id == camperID})!.cabin]!.campers.removeAll(where: {$0.id == camperID})
        //remove camper from skills
        for i in 0...3 {
            data.skills[data.campers.first(where: {$0.id == camperID})!.skills[i]]!.periods[i].removeAll(where: {$0.id == camperID})
        }
        //delete camper for good
        data.campers.removeAll(where: {$0.id == camperID})
    }
}
