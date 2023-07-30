//
//  FanaticOperations.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-28.
//

import Foundation

func createFanatic(newFanatic: Fanatic){
    fooFanatics[newFanatic.name] = newFanatic
    fooSkills[newFanatic.name] = try! Skill(name: newFanatic.name, maximums: [newFanatic.activePeriods[0] ? 255 : 0,
                                                                              newFanatic.activePeriods[1] ? 255 : 0,
                                                                              newFanatic.activePeriods[2] ? 255 : 0,
                                                                              newFanatic.activePeriods[3] ? 255 : 0])
}

func deleteFanatic(fanaticName: String){
    
}
