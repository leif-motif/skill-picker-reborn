//
//  CSVOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-08-01.
//

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
        createCabin(cabinName: String(name), targetSenior: nullSenior, targetJunior: nullJunior, data: data)
    }
}

func skillListFromCSV(csv: [Substring]) -> [String:Bool] {
    var isFanatic: [String:Bool] = [:]
    let lazyNumbers: [Substring] = ["1","2","3","4","5","6"]
    for x in 0...(csv[0].collumns.count-1) {
        if(csv[0].collumns[x] != "Name" && csv[0].collumns[x] != "Cabin"){
            for y in 1...(csv.count-1){
                if(csv[y].collumns[x] == "TRUE"){
                    isFanatic[String(csv[0].collumns[x])] = true
                    break
                } else if (lazyNumbers.contains(csv[y].collumns[x])){
                    isFanatic[String(csv[0].collumns[x])] = false
                    break
                }
            }
        }
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

func cabinListToCSV(cabinName: String) throws -> String {
    return ""
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

func skillListToCSV(skillName: String, skillPeriod: Int) throws -> String {
    return ""
}

func fanaticListToCSV(fanaticName: String) throws -> String {
    return ""
}
