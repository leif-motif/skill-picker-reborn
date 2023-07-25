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
    var campers: [Camper] = []
    init(name: String, senior: Leader, junior: Leader) throws {
        self.name = name
        if(!senior.senior){
            throw ValueError.NotASenior
        } else {
            self.senior = senior
        }
        if(junior.senior){
            throw ValueError.NotAJunior
        } else {
            self.junior = junior
        }
    }
}
