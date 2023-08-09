/*
 * LeaderOperations.swift
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

func createLeader(newLeader: Leader, data: CampData){
    data.leaders.append(newLeader)
    if(newLeader.senior){
        //if this new leader is going to be assigned a cabin and the cabin leader at that cabin is not the null leader
        if(newLeader.cabin != "Unassigned" && data.cabins[newLeader.cabin]!.senior.id != data.nullSenior.id){
            //set the old leader's cabin as unassigned
            data.cabins[newLeader.cabin]!.senior.cabin = "Unassigned"
        }
        data.cabins[newLeader.cabin]!.senior = newLeader
    } else {
        if(newLeader.cabin != "Unassigned" && data.cabins[newLeader.cabin]!.junior.id != data.nullJunior.id){
            data.cabins[newLeader.cabin]!.junior.cabin = "Unassigned"
        }
        data.cabins[newLeader.cabin]!.junior = newLeader
    }
    for i in 0...3 {
        data.skills[newLeader.skills[i]]!.leaders[i].append(newLeader)
    }
}

func deleteLeader(leaderSelection: Set<Leader.ID>, data: CampData){
    for leaderID in leaderSelection {
        //fooLeaders.first(where: {$0.id == leaderID})
        //remove leader from cabin if not unassigned
        if(data.leaders.first(where: {$0.id == leaderID})!.cabin != "Unassigned"){
            if(data.leaders.first(where: {$0.id == leaderID})!.senior){
                data.cabins[data.leaders.first(where: {$0.id == leaderID})!.cabin]!.senior = data.nullSenior
            } else {
                data.cabins[data.leaders.first(where: {$0.id == leaderID})!.cabin]!.junior = data.nullJunior
            }
        }
        //remove leader from skills
        for i in 0...3 {
            data.skills[data.leaders.first(where: {$0.id == leaderID})!.skills[i]]!.leaders[i].removeAll(where: {$0.id == leaderID})
        }
        //delete leader for good
        data.leaders.removeAll(where: {$0.id == leaderID})
    }
}
