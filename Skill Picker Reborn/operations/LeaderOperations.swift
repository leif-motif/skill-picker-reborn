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

extension CampData {
    func createLeader(newLeader: Leader, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        self.c.leaders.insert(newLeader)
        if(newLeader.senior){
            //if this new leader is going to be assigned a cabin and the cabin leader at that cabin is not the null leader
            if(newLeader.cabin != "Unassigned" && self.c.cabins[newLeader.cabin]!.senior.id != self.c.nullSenior.id){
                //set the old leader's cabin as unassigned
                self.c.cabins[newLeader.cabin]!.senior.cabin = "Unassigned"
            }
            self.c.cabins[newLeader.cabin]!.senior = newLeader
        } else {
            if(newLeader.cabin != "Unassigned" && self.c.cabins[newLeader.cabin]!.junior.id != self.c.nullJunior.id){
                self.c.cabins[newLeader.cabin]!.junior.cabin = "Unassigned"
            }
            self.c.cabins[newLeader.cabin]!.junior = newLeader
        }
        for i in 0...3 {
            self.c.skills[newLeader.skills[i]]!.leaders[i].insert(newLeader)
        }
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in createLeader")
            }
        }
    }
    
    func deleteLeader(leaderID: Leader.ID, usingInternally: Bool = false){
        if(!usingInternally){
            self.objectWillChange.send()
        }
        
        //remove leader from cabin if not unassigned
        if(self.getLeader(leaderID: leaderID)!.cabin != "Unassigned"){
            if(self.getLeader(leaderID: leaderID)!.senior){
                self.c.cabins[self.getLeader(leaderID: leaderID)!.cabin]!.senior = self.c.nullSenior
            } else {
                self.c.cabins[self.getLeader(leaderID: leaderID)!.cabin]!.junior = self.c.nullJunior
            }
        }
        //remove leader from skills
        for i in 0...3 {
            self.c.skills[self.getLeader(leaderID: leaderID)!.skills[i]]!.leaders[i].remove(self.getLeader(leaderID: leaderID)!)
        }
        //delete leader for good
        self.c.leaders.remove(self.getLeader(leaderID: leaderID)!)
        
        if(!usingInternally){
            self.undoManager.registerUndo(withTarget: self.c){ _ in
                #warning("TODO: implement undo in deleteLeader")
            }
        }
    }
}
