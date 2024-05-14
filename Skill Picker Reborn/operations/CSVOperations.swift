/*
 * CSVOperations.swift
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

func cabinsFromCSV(csv: [Substring], data: CampData){
    var cabinIndex: Int?
    var cabinNames: [Substring] = []
    for x in 0...(csv[0].collumns.count-1){
        if(csv[0].collumns[x] == "Cabin"){
            cabinIndex = x
            break
        }
    }
    for x in 1...(csv.count-1){
        if(!cabinNames.contains(csv[x].collumns[cabinIndex!])){
            cabinNames.append(csv[x].collumns[cabinIndex!])
        }
    }
    cabinNames.sort()
    for name in cabinNames {
        createCabin(cabinName: String(name), targetSenior: data.nullSenior, targetJunior: data.nullJunior, data: data)
    }
}

func skillListFromCSV(csv: [Substring]) throws -> [String:Bool] {
    var isFanatic: [String:Bool] = [:]
    let lazyNumbers: [Substring] = ["1","2","3","4","5","6"]
    for x in 0...(csv[0].collumns.count-1) {
        if(csv[0].collumns[x] != "Name" && csv[0].collumns[x] != "Cabin"){
            for y in 1...(csv.count-1){
                if(csv[y].collumns[x] == ""){
                    continue
                } else if(csv[y].collumns[x] == "TRUE"){
                    isFanatic[String(csv[0].collumns[x])] = true
                    break
                } else if(lazyNumbers.contains(csv[y].collumns[x])){
                    isFanatic[String(csv[0].collumns[x])] = false
                    break
                } else {
                    throw SPRError.InvalidFileFormat
                }
            }
            if(!isFanatic.keys.contains(String(csv[0].collumns[x]))){
                throw SPRError.InvalidFileFormat
            }
        }
    }
    if(isFanatic == [:]){
        throw SPRError.InvalidFileFormat
    }
    return isFanatic
}

func campersFromCSV(csv: [Substring], data: CampData) throws {
    let numbers = ["1","2","3","4","5","6"]
    var fName: String
    var lName: String
    var cabinName: String
    var fanatic: String
    for i in 1...(csv.count-1){
        let nameComponents = csv[i].collumns[0].components(separatedBy: " ")
        if(nameComponents.count < 2){
            throw SPRError.ReallyBadName
        }
        fName = nameComponents.first!
        var x = 1
        while(x < nameComponents.count-1){
            fName = fName+" "+nameComponents[x]
            x += 1
        }
        lName = nameComponents.last!
        cabinName = String(csv[i].collumns[1])
        fanatic = "None"
        var preferredNullSkills: [String?] = [nil,nil,nil,nil,nil,nil]
        for j in 2...(csv[i].collumns.count-1){
            if(csv[i].collumns[j] == "TRUE"){
                fanatic = String(csv[0].collumns[j])
            } else if(numbers.contains(String(csv[i].collumns[j]))){
                preferredNullSkills[Int(csv[i].collumns[j])!-1] = String(csv[0].collumns[j])
            }
        }
        var preferredSkills: [String] = []
        for skill in preferredNullSkills {
            if(skill != nil){
                preferredSkills.append(skill!)
            }
        }
        if(fanatic != "None" && preferredSkills.count == 6){
            preferredSkills.remove(at: 5)
        }
        while(preferredSkills.count < (fanatic == "None" ? 6 : 5)){
            preferredSkills.append("None")
        }
        try createCamper(newCamper: try! Camper(fName: fName, lName: lName, cabin: cabinName, preferredSkills: preferredSkills, fanatic: fanatic), data: data)
    }
}

func cabinListToCSV(cabinName: String, data: CampData) -> String {
    let cabin = data.cabins[cabinName]!
    var csv = "\(cabinName)\n,Name,Skill 1,Skill 2,Skill 3,Skill 4\n"
    csv += "Senior,\(cabin.senior.fName) \(cabin.senior.lName),\(cabin.senior.skills[0]),\(cabin.senior.skills[1]),\(cabin.senior.skills[2]),\(cabin.senior.skills[3])\n"
    csv += "Junior,\(cabin.junior.fName) \(cabin.junior.lName),\(cabin.junior.skills[0]),\(cabin.junior.skills[1]),\(cabin.junior.skills[2]),\(cabin.junior.skills[3])\nCampers,"
    for camper in cabin.campers.sorted(using: KeyPathComparator(\Camper.lName)) {
        csv += "\(camper.fName) \(camper.lName),\(camper.skills[0]),\(camper.skills[1]),\(camper.skills[2]),\(camper.skills[3])\n,"
    }
    return csv
}

func camperListToCSV(data: CampData) -> String {
    var csv = "Name,Cabin,Skill 1,Skill 2,Skill 3, Skill 4"
    for camper in data.campers.sorted(using: KeyPathComparator(\Camper.lName)) {
        csv += "\n\(camper.fName) \(camper.lName),\(camper.cabin),\(camper.skills[0]),\(camper.skills[1]),\(camper.skills[2]),\(camper.skills[3])"
    }
    return csv
}

func leaderListToCSV(data: CampData) -> String {
    var csv = "Leader,Cabin,Skill 1,Skill 2,Skill 3, Skill 4"
    for leader in data.leaders.sorted(using: KeyPathComparator(\Leader.lName)) {
        csv += "\n\(leader.fName) \(leader.lName),\(leader.cabin),\(leader.skills[0]),\(leader.skills[1]),\(leader.skills[2]),\(leader.skills[3])"
    }
    return csv
}

func skillListToCSV(skillName: String, skillPeriod: Int, data: CampData) -> String {
    var csv = "\(skillName),Skill \(skillPeriod+1)\nLeaders,Name,Cabin"
    for leader in data.skills[skillName]!.leaders[skillPeriod].sorted(using: KeyPathComparator(\Leader.lName)) {
        csv += "\n,\(leader.fName) \(leader.lName),\(leader.cabin)"
    }
    csv += "\nCampers"
    for camper in data.skills[skillName]!.periods[skillPeriod].sorted(using: KeyPathComparator(\Camper.cabin)) {
        csv += ",\(camper.fName) \(camper.lName),\(camper.cabin)\n"
    }
    return csv
}

func fanaticListToCSV(fanaticName: String, data: CampData) -> String {
    var p: Int?
    for i in 0...3 {
        if(data.fanatics[fanaticName]!.activePeriods[i]){
            p = i
            break
        }
    }
    var csv = "\(fanaticName)\nLeaders,Name,Cabin"
    for leader in data.skills[fanaticName]!.leaders[p!].sorted(using: KeyPathComparator(\Leader.lName)) {
        csv += "\n,\(leader.fName) \(leader.lName),\(leader.cabin)"
    }
    csv += "\nCampers"
    for camper in data.skills[fanaticName]!.periods[p!].sorted(using: KeyPathComparator(\Camper.cabin)) {
        csv += ",\(camper.fName) \(camper.lName),\(camper.cabin)\n"
    }
    return csv
}
