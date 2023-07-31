//
//  LeaderOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-27.
//

import Foundation

func createLeader(newLeader: Leader){
    fooLeaders.append(newLeader)
    if(newLeader.senior){
        //if this new leader is going to be assigned a cabin and the cabin leader at that cabin is not the null leader
        if(newLeader.cabin != "Unassigned" && fooCabins[newLeader.cabin]!.senior.id != nullSenior.id){
            //set the leader's cabin as unassigned
            fooCabins[newLeader.cabin]!.senior.cabin = "Unassigned"
        }
        fooCabins[newLeader.cabin]!.senior = newLeader
    } else {
        if(newLeader.cabin != "Unassigned" && fooCabins[newLeader.cabin]!.junior.id != nullJunior.id){
            fooCabins[newLeader.cabin]!.junior.cabin = "Unassigned"
        }
        fooCabins[newLeader.cabin]!.junior = newLeader
    }
    for i in 0...3 {
        fooSkills[newLeader.skills[i]]!.leaders[i].append(newLeader)
    }
}

func deleteLeader(leaderSelection: Set<Leader.ID>){
    for leaderID in leaderSelection {
        //fooLeaders.first(where: {$0.id == leaderID})
        //remove leader from cabin if not unassigned
        if(fooLeaders.first(where: {$0.id == leaderID})!.cabin != "Unassigned"){
            if(fooLeaders.first(where: {$0.id == leaderID})!.senior){
                fooCabins[fooLeaders.first(where: {$0.id == leaderID})!.cabin]!.senior = nullSenior
            } else {
                fooCabins[fooLeaders.first(where: {$0.id == leaderID})!.cabin]!.junior = nullJunior
            }
        }
        //remove leader from skills
        for i in 0...3 {
            fooSkills[fooLeaders.first(where: {$0.id == leaderID})!.skills[i]]!.leaders[i].removeAll(where: {$0.id == leaderID})
        }
        //delete leader for good
        fooLeaders.removeAll(where: {$0.id == leaderID})
    }
}
