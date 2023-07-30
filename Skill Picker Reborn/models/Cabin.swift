//
//  Cabin.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import Foundation

class Cabin {
    var name: String
    var senior: Leader
    var junior: Leader
    var campers: [Camper]
    init(name: String, senior: Leader, junior: Leader, campers: [Camper] = []) throws {
        self.name = name
        if(!senior.senior){
            throw SPRError.NotASenior
        } else {
            self.senior = senior
        }
        if(junior.senior){
            throw SPRError.NotAJunior
        } else {
            self.junior = junior
        }
        self.campers = campers
    }
}
