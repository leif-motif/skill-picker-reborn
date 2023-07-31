//
//  LeaderOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createLeader(newLeader: Leader){
    leaders.append(newLeader)
    if(newLeader.senior){
        //if this new leader is going to be assigned a cabin and the cabin leader at that cabin is not the null leader
        if(newLeader.cabin != "Unassigned" && cabins[newLeader.cabin]!.senior.id != nullSenior.id){
            //set the old leader's cabin as unassigned
            cabins[newLeader.cabin]!.senior.cabin = "Unassigned"
        }
        cabins[newLeader.cabin]!.senior = newLeader
    } else {
        if(newLeader.cabin != "Unassigned" && cabins[newLeader.cabin]!.junior.id != nullJunior.id){
            cabins[newLeader.cabin]!.junior.cabin = "Unassigned"
        }
        cabins[newLeader.cabin]!.junior = newLeader
    }
    for i in 0...3 {
        skills[newLeader.skills[i]]!.leaders[i].append(newLeader)
    }
}

func deleteLeader(leaderSelection: Set<Leader.ID>){
    for leaderID in leaderSelection {
        //fooLeaders.first(where: {$0.id == leaderID})
        //remove leader from cabin if not unassigned
        if(leaders.first(where: {$0.id == leaderID})!.cabin != "Unassigned"){
            if(leaders.first(where: {$0.id == leaderID})!.senior){
                cabins[leaders.first(where: {$0.id == leaderID})!.cabin]!.senior = nullSenior
            } else {
                cabins[leaders.first(where: {$0.id == leaderID})!.cabin]!.junior = nullJunior
            }
        }
        //remove leader from skills
        for i in 0...3 {
            skills[leaders.first(where: {$0.id == leaderID})!.skills[i]]!.leaders[i].removeAll(where: {$0.id == leaderID})
        }
        //delete leader for good
        leaders.removeAll(where: {$0.id == leaderID})
    }
}
