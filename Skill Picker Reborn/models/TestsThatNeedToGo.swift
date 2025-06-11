/*
 * TestsThatNeedToGo.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2025 Ranger Lake Bible Camp
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

extension CampData {
    func createTestingData(data: CampData){
        self.createCabin(cabinName: "1", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "2", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "A", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "B", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        
        self.createSkill(newSkill: try! Skill(name: "Archery", maximums: [10,10,0,10]), usingInternally: true)
        self.createSkill(newSkill: try! Skill(name: "Backcountry", maximums: [10,0,10,10]), usingInternally: true)
        
        self.createFanatic(newFanatic: try! Fanatic(name: "Paintball", activePeriods: [false,false,true,true]), usingInternally: true)
        
        try! self.createCamper(newCamper: try! Camper(fName: "Bart", lName: "Simpson", cabin: "1",
                                                 preferredSkills: ["Wall Climbing","Horses","Swimming","Drama","Crafts"],
                                                 fanatic: "Paintball",
                                                 skills: ["Archery","None","None","None"]), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Bugs", lName: "Bunny", cabin: "1",
                                                 preferredSkills: ["Horses","Archery","Pelletry","Crafts","Ultimate","Drama"],
                                                 fanatic: "None",
                                                 skills: ["Backcountry","None","None","Archery"]), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Eric", lName: "Cartman", cabin: "2",
                                                 preferredSkills: ["Pelletry","Backcountry","Archery","Wall Climbing","Horses"],
                                                 fanatic: "Paintball",
                                                 skills: ["Archery","None","None","None"]), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Daffy", lName: "Duck", cabin: "2",
                                                 preferredSkills: ["Archery","Pelletry","Wall Climbing","Ultimate","Swimming","Horses"],
                                                 fanatic: "None",
                                                 skills: ["Archery","None","None","None"]), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Suzy", lName: "Johnson", cabin: "A",
                                                 preferredSkills: ["Pelletry","Archery","Backcountry","Ultimate","Horses"],
                                                 fanatic: "Paintball",
                                                 skills: ["Archery","None","None","None"]), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Sandy", lName: "Cheeks", cabin: "A",
                                                 preferredSkills: ["Crafts","Backcountry","Horses","Drama","Ultimate","Canoeing"],
                                                 fanatic: "None",
                                                 skills: ["None","Archery","Backcountry","None"]), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Lisa", lName: "Simpson", cabin: "B",
                                                 preferredSkills: ["Canoeing","Archery","Drama","Backcountry","Horses","Ultimate"],
                                                 fanatic: "None",
                                                 skills: ["None","None","Backcountry","Archery"]), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Velma", lName: "Dinkley", cabin: "B",
                                                 preferredSkills: ["Crafts","Backcountry","Horses","Wall Climbing","Ultimate","Canoeing"],
                                                 fanatic: "None",
                                                 skills: ["Backcountry","None","None","Archery"]), usingInternally: true)
        
        self.createLeader(newLeader: try! Leader(fName: "Joe", lName: "Biden", cabin: "1", senior: true,
                                            skills: ["Archery",    "None",   "None",       "Backcountry"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Snoop", lName: "Dogg", cabin: "1", senior: false,
                                            skills: ["Backcountry","None",   "Paintball",  "Paintball"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Donald", lName: "Trump", cabin: "2", senior: true,
                                            skills: ["Backcountry","Archery","Paintball",  "Paintball"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Justin", lName: "Bieber", cabin: "2", senior: false,
                                            skills: ["None","None","None","None"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Hilary", lName: "Clinton", cabin: "A", senior: true,
                                            skills: ["None",       "None",   "None",       "Archery"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Doja", lName: "Cat", cabin: "A", senior: false,
                                            skills: ["Archery",    "None",   "Backcountry","Archery"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Greta", lName: "Thunberg", cabin: "B", senior: true,
                                            skills: ["None",       "Archery","Backcountry","Backcountry"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Nikki", lName: "Minaj", cabin: "B", senior: false,
                                            skills: ["None","None","None","None"]), usingInternally: true)
    }
    
    func createTestingDataPlus(data: CampData){
        self.createCabin(cabinName: "1", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "2", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "3", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "A", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "B", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        self.createCabin(cabinName: "C", targetSenior: data.c.nullSenior, targetJunior: data.c.nullJunior, usingInternally: true)
        
        self.createSkill(newSkill: try! Skill(name: "Archery", maximums: [10,10,0,10]), usingInternally: true)
        self.createSkill(newSkill: try! Skill(name: "Backcountry", maximums: [10,0,10,10]), usingInternally: true)
        self.createSkill(newSkill: try! Skill(name: "Horses", maximums: [10,10,10,0]), usingInternally: true)
        self.createSkill(newSkill: try! Skill(name: "Pelletry", maximums: [10,10,10,0]), usingInternally: true)
        self.createSkill(newSkill: try! Skill(name: "Ultimate", maximums: [0,10,10,10]), usingInternally: true)
        self.createSkill(newSkill: try! Skill(name: "Wall Climbing", maximums: [10,10,0,10]), usingInternally: true)
        
        self.createFanatic(newFanatic: try! Fanatic(name: "Paintball", activePeriods: [false,false,true,true]), usingInternally: true)
        self.createFanatic(newFanatic: try! Fanatic(name: "Tabletop Adventure", activePeriods: [true,true,false,false]), usingInternally: true)
        
        try! self.createCamper(newCamper: try! Camper(fName: "Bart", lName: "Simpson", cabin: "1",
                                                 preferredSkills: ["Wall Climbing","Archery","Backcountry","Pelletry","Ultimate"],
                                                 fanatic: "Paintball"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Bugs", lName: "Bunny", cabin: "1",
                                                 preferredSkills: ["Horses","Archery","Pelletry","Wall Climbing","Ultimate","Backcountry"],
                                                 fanatic: "None"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Eric", lName: "Cartman", cabin: "2",
                                                 preferredSkills: ["Pelletry","Backcountry","Archery","Wall Climbing","Horses"],
                                                 fanatic: "Paintball"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Daffy", lName: "Duck", cabin: "2",
                                                 preferredSkills: ["Archery","Pelletry","Wall Climbing","Backcountry","Ultimate","Horses"],
                                                 fanatic: "None"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Fred", lName: "Flintstone", cabin: "3",
                                                 preferredSkills: ["Horses","Pelletry","Archery","Wall Climbing","Ultimate"],
                                                 fanatic: "Tabletop Adventure"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Sid", lName: "Sloth", cabin: "3",
                                                 preferredSkills: ["Wall Climbing","Horses","Archery","Ultimate","Pelletry"],
                                                 fanatic: "Tabletop Adventure"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Suzy", lName: "Johnson", cabin: "A",
                                                 preferredSkills: ["Pelletry","Archery","Backcountry","Ultimate","Horses"],
                                                 fanatic: "Paintball"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Sandy", lName: "Cheeks", cabin: "A",
                                                 preferredSkills: ["Wall Climbing","Backcountry","Horses","Archery","Ultimate"],
                                                 fanatic: "Tabletop Adventure"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Lisa", lName: "Simpson", cabin: "B",
                                                 preferredSkills: ["Pelletry","Archery","Wall Climbing","Backcountry","Horses","Ultimate"],
                                                 fanatic: "None"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Velma", lName: "Dinkley", cabin: "B",
                                                 preferredSkills: ["Archery","Backcountry","Horses","Wall Climbing","Ultimate","Pelletry"],
                                                 fanatic: "None"), usingInternally: true)
        try! self.createCamper(newCamper: try! Camper(fName: "Wilma", lName: "Flintstone", cabin: "C",
                                                 preferredSkills: ["Backcountry","Horses","Wall Climbing","Ultimate","Pelletry","Archery"],
                                                 fanatic: "None"), usingInternally: true)
        
        self.createLeader(newLeader: try! Leader(fName: "Joe", lName: "Biden", cabin: "1", senior: true,
                                            skills: ["Archery",       "Pelletry",      "None",       "Backcountry"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Snoop", lName: "Dogg", cabin: "1", senior: false,
                                            skills: ["Backcountry",   "None",          "Paintball",  "Paintball"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Donald", lName: "Trump", cabin: "2", senior: true,
                                            skills: ["Backcountry",   "Archery",       "Paintball",  "Paintball"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Justin", lName: "Bieber", cabin: "2", senior: false,
                                            skills: ["None",          "Ultimate",          "None","None"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "George", lName: "Bush", cabin: "3", senior: true,
                                            skills: ["Pelletry",      "Wall Climbing", "None",       "Ultimate"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Ryan", lName: "Reynolds", cabin: "3", senior: false,
                                            skills: ["Wall Climbing", "None",          "Pelletry",   "Wall Climbing"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Hilary", lName: "Clinton", cabin: "A", senior: true,
                                            skills: ["Wall Climbing", "None",          "Pelletry",   "Archery"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Doja", lName: "Cat", cabin: "A", senior: false,
                                            skills: ["Archery",       "None",          "Backcountry","Archery"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Greta", lName: "Thunberg", cabin: "B", senior: true,
                                            skills: ["None",          "Archery",       "Backcountry","Backcountry"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Nikki", lName: "Minaj", cabin: "B", senior: false,
                                            skills: ["Pelletry",      "Pelletry",      "None","None"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Michelle", lName: "Obama", cabin: "C", senior: true,
                                            skills: ["None",          "Ultimate",      "Ultimate",   "Wall Climbing"]), usingInternally: true)
        self.createLeader(newLeader: try! Leader(fName: "Celine", lName: "Dion", cabin: "C", senior: false,
                                            skills: ["None",          "Wall Climbing","Ultimate",    "Ultimate"]), usingInternally: true)
    }
}
