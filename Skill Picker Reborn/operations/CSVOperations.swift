//
//  CSVOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-08-01.
//

import Foundation

func cabinsFromCSV(csv: [Substring]){
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
        createCabin(cabinName: String(name), targetSenior: nullSenior, targetJunior: nullJunior)
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

func campersFromCSV(csv: [Substring]) throws {
    let numbers = ["1","2","3","4","5","6"]
    var fName: String
    var lName: String
    var cabinName: String
    var fanatic: String
    for i in 1...(csv.count-1){
        var nameComponents = csv[i].collumns[0].components(separatedBy: " ")
        if(nameComponents.count < 2){
            throw SPRError.ReallyBadName
        }
        fName = nameComponents.first!
        var i = 1
        while(i < nameComponents.count-1){
            fName = fName+" "+nameComponents[i]
            i += 1
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
            preferredSkills.append("")
        }
        try createCamper(newCamper: try! Camper(fName: fName, lName: lName, cabin: cabinName, preferredSkills: preferredSkills, fanatic: fanatic))
    }
}
