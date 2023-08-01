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

func skillsFromCSV(csv: [Substring]){
    
}

func campersFromCSV(csv: [Substring]){
    
}
