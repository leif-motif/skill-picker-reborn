/*
 * LeaderOperations.swift
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

func createLeader(newLeader: Leader, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    data.c.leaders.insert(newLeader)
    if(newLeader.senior){
        //if this new leader is going to be assigned a cabin and the cabin leader at that cabin is not the null leader
        if(newLeader.cabin != "Unassigned" && data.c.cabins[newLeader.cabin]!.senior.id != data.c.nullSenior.id){
            //set the old leader's cabin as unassigned
            data.c.cabins[newLeader.cabin]!.senior.cabin = "Unassigned"
        }
        data.c.cabins[newLeader.cabin]!.senior = newLeader
    } else {
        if(newLeader.cabin != "Unassigned" && data.c.cabins[newLeader.cabin]!.junior.id != data.c.nullJunior.id){
            data.c.cabins[newLeader.cabin]!.junior.cabin = "Unassigned"
        }
        data.c.cabins[newLeader.cabin]!.junior = newLeader
    }
    for i in 0...3 {
        data.c.skills[newLeader.skills[i]]!.leaders[i].insert(newLeader)
    }
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in createLeader")
        }
    }
}

func deleteLeader(leaderID: Leader.ID, data: CampData, usingInternally: Bool = false){
    if(!usingInternally){
        data.objectWillChange.send()
    }
    
    //remove leader from cabin if not unassigned
    if(data.c.getLeader(leaderID: leaderID)!.cabin != "Unassigned"){
        if(data.c.getLeader(leaderID: leaderID)!.senior){
            data.c.cabins[data.c.getLeader(leaderID: leaderID)!.cabin]!.senior = data.c.nullSenior
        } else {
            data.c.cabins[data.c.getLeader(leaderID: leaderID)!.cabin]!.junior = data.c.nullJunior
        }
    }
    //remove leader from skills
    for i in 0...3 {
        data.c.skills[data.c.getLeader(leaderID: leaderID)!.skills[i]]!.leaders[i].remove(data.c.getLeader(leaderID: leaderID)!)
    }
    //delete leader for good
    data.c.leaders.remove(data.c.getLeader(leaderID: leaderID)!)
    
    if(!usingInternally){
        data.undoManager.registerUndo(withTarget: data.c){ _ in
            #warning("TODO: implement undo in deleteLeader")
        }
    }
}
