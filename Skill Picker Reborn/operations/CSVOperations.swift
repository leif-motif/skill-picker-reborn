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

func campersFromCSV(csv: [Substring]){
    
}
