//
//  TestsThatNeedToGo.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import Foundation

func createTestingData(){
    createCabin(cabinName: "1", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "2", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "A", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "B", targetSenior: nullSenior, targetJunior: nullJunior)
    
    createSkill(newSkill: try! Skill(name: "Archery", maximums: [10,10,0,10]))
    createSkill(newSkill: try! Skill(name: "Backcountry", maximums: [10,0,10,10]))
    
    createFanatic(newFanatic: try! Fanatic(name: "Paintball", activePeriods: [false,false,true,true]))
    
    try! createCamper(newCamper: try! Camper(fName: "Bart", lName: "Simpson", cabin: "1",
                                             preferredSkills: ["Wall Climbing","Horses","Swimming","Drama","Crafts"],
                                             fanatic: "Paintball",
                                             skills: ["Archery","None","None","None"]))
    try! createCamper(newCamper: try! Camper(fName: "Bugs", lName: "Bunny", cabin: "1",
                                             preferredSkills: ["Horses","Archery","Pelletry","Crafts","Ultimate","Drama"],
                                             fanatic: "None",
                                             skills: ["Backcountry","None","None","Archery"]))
    try! createCamper(newCamper: try! Camper(fName: "Eric", lName: "Cartman", cabin: "2",
                                             preferredSkills: ["Pelletry","Backcountry","Archery","Wall Climbing","Horses"],
                                             fanatic: "Paintball",
                                             skills: ["Archery","None","None","None"]))
    try! createCamper(newCamper: try! Camper(fName: "Daffy", lName: "Duck", cabin: "2",
                                             preferredSkills: ["Archery","Pelletry","Wall Climbing","Ultimate","Swimming","Horses"],
                                             fanatic: "None",
                                             skills: ["Archery","None","None","None"]))
    try! createCamper(newCamper: try! Camper(fName: "Suzy", lName: "Johnson", cabin: "A",
                                             preferredSkills: ["Pelletry","Archery","Backcountry","Ultimate","Horses"],
                                             fanatic: "Paintball",
                                             skills: ["Archery","None","None","None"]))
    try! createCamper(newCamper: try! Camper(fName: "Sandy", lName: "Cheeks", cabin: "A",
                                             preferredSkills: ["Crafts","Backcountry","Horses","Drama","Ultimate","Canoeing"],
                                             fanatic: "None",
                                             skills: ["None","Archery","Backcountry","None"]))
    try! createCamper(newCamper: try! Camper(fName: "Lisa", lName: "Simpson", cabin: "B",
                                             preferredSkills: ["Canoeing","Archery","Drama","Backcountry","Horses","Ultimate"],
                                             fanatic: "None",
                                             skills: ["None","None","Backcountry","Archery"]))
    try! createCamper(newCamper: try! Camper(fName: "Velma", lName: "Dinkley", cabin: "B",
                                             preferredSkills: ["Crafts","Backcountry","Horses","Wall Climbing","Ultimate","Canoeing"],
                                             fanatic: "None",
                                             skills: ["Backcountry","None","None","Archery"]))
    
    createLeader(newLeader: try! Leader(fName: "Joe", lName: "Biden", cabin: "1", senior: true,
                                        skills: ["Archery",    "None",   "None",       "Backcountry"]))
    createLeader(newLeader: try! Leader(fName: "Snoop", lName: "Dogg", cabin: "1", senior: false,
                                        skills: ["Backcountry","None",   "Paintball",  "Paintball"]))
    createLeader(newLeader: try! Leader(fName: "Donald", lName: "Trump", cabin: "2", senior: true,
                                        skills: ["Backcountry","Archery","Paintball",  "Paintball"]))
    createLeader(newLeader: try! Leader(fName: "Justin", lName: "Bieber", cabin: "2", senior: false,
                                        skills: ["None","None","None","None"]))
    createLeader(newLeader: try! Leader(fName: "Hilary", lName: "Clinton", cabin: "A", senior: true,
                                        skills: ["None",       "None",   "None",       "Archery"]))
    createLeader(newLeader: try! Leader(fName: "Doja", lName: "Cat", cabin: "A", senior: false,
                                        skills: ["Archery",    "None",   "Backcountry","Archery"]))
    createLeader(newLeader: try! Leader(fName: "Greta", lName: "Thunberg", cabin: "B", senior: true,
                                        skills: ["None",       "Archery","Backcountry","Backcountry"]))
    createLeader(newLeader: try! Leader(fName: "Nikki", lName: "Minaj", cabin: "B", senior: false,
                                        skills: ["None","None","None","None"]))
}

func createTestingDataPlus(){
    createCabin(cabinName: "1", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "2", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "3", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "A", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "B", targetSenior: nullSenior, targetJunior: nullJunior)
    createCabin(cabinName: "C", targetSenior: nullSenior, targetJunior: nullJunior)
    
    createSkill(newSkill: try! Skill(name: "Archery", maximums: [10,10,0,10]))
    createSkill(newSkill: try! Skill(name: "Backcountry", maximums: [10,0,10,10]))
    createSkill(newSkill: try! Skill(name: "Horses", maximums: [10,10,10,0]))
    createSkill(newSkill: try! Skill(name: "Pelletry", maximums: [10,10,10,0]))
    createSkill(newSkill: try! Skill(name: "Ultimate", maximums: [0,10,10,10]))
    createSkill(newSkill: try! Skill(name: "Wall Climbing", maximums: [10,10,0,10]))
    
    createFanatic(newFanatic: try! Fanatic(name: "Paintball", activePeriods: [false,false,true,true]))
    createFanatic(newFanatic: try! Fanatic(name: "Tabletop Adventure", activePeriods: [true,true,false,false]))
    
    try! createCamper(newCamper: try! Camper(fName: "Bart", lName: "Simpson", cabin: "1",
                                             preferredSkills: ["Wall Climbing","Archery","Backcountry","Pelletry","Ultimate"],
                                             fanatic: "Paintball"))
    try! createCamper(newCamper: try! Camper(fName: "Bugs", lName: "Bunny", cabin: "1",
                                             preferredSkills: ["Horses","Archery","Pelletry","Wall Climbing","Ultimate","Backcountry"],
                                             fanatic: "None"))
    try! createCamper(newCamper: try! Camper(fName: "Eric", lName: "Cartman", cabin: "2",
                                             preferredSkills: ["Pelletry","Backcountry","Archery","Wall Climbing","Horses"],
                                             fanatic: "Paintball"))
    try! createCamper(newCamper: try! Camper(fName: "Daffy", lName: "Duck", cabin: "2",
                                             preferredSkills: ["Archery","Pelletry","Wall Climbing","Ultimate","Ultimate","Horses"],
                                             fanatic: "None"))
    try! createCamper(newCamper: try! Camper(fName: "Fred", lName: "Flintstone", cabin: "3",
                                             preferredSkills: ["Horses","Pelletry","Archery","Wall Climbing","Ultimate"],
                                             fanatic: "Tabletop Adventure"))
    try! createCamper(newCamper: try! Camper(fName: "Sid", lName: "Sloth", cabin: "3",
                                             preferredSkills: ["Wall Climbing","Horses","Archery","Ultimate","Pelletry"],
                                             fanatic: "Tabletop Adventure"))
    try! createCamper(newCamper: try! Camper(fName: "Suzy", lName: "Johnson", cabin: "A",
                                             preferredSkills: ["Pelletry","Archery","Backcountry","Ultimate","Horses"],
                                             fanatic: "Paintball"))
    try! createCamper(newCamper: try! Camper(fName: "Sandy", lName: "Cheeks", cabin: "A",
                                             preferredSkills: ["Wall Climbing","Backcountry","Horses","Archery","Ultimate"],
                                             fanatic: "Tabletop Adventure"))
    try! createCamper(newCamper: try! Camper(fName: "Lisa", lName: "Simpson", cabin: "B",
                                             preferredSkills: ["Pelletry","Archery","Wall Climbing","Backcountry","Horses","Ultimate"],
                                             fanatic: "None"))
    try! createCamper(newCamper: try! Camper(fName: "Velma", lName: "Dinkley", cabin: "B",
                                             preferredSkills: ["Archery","Backcountry","Horses","Wall Climbing","Ultimate","Pelletry"],
                                             fanatic: "None"))
    try! createCamper(newCamper: try! Camper(fName: "Wilma", lName: "Flintstone", cabin: "C",
                                             preferredSkills: ["Backcountry","Horses","Wall Climbing","Ultimate","Pelletry","Archery"],
                                             fanatic: "None"))
    
    createLeader(newLeader: try! Leader(fName: "Joe", lName: "Biden", cabin: "1", senior: true,
                                        skills: ["Archery",       "Pelletry",      "None",       "Backcountry"]))
    createLeader(newLeader: try! Leader(fName: "Snoop", lName: "Dogg", cabin: "1", senior: false,
                                        skills: ["Backcountry",   "None",          "Paintball",  "Paintball"]))
    createLeader(newLeader: try! Leader(fName: "Donald", lName: "Trump", cabin: "2", senior: true,
                                        skills: ["Backcountry",   "Archery",       "Paintball",  "Paintball"]))
    createLeader(newLeader: try! Leader(fName: "Justin", lName: "Bieber", cabin: "2", senior: false,
                                        skills: ["None",          "Ultimate",          "None","None"]))
    createLeader(newLeader: try! Leader(fName: "George", lName: "Bush", cabin: "3", senior: true,
                                        skills: ["Pelletry",      "Wall Climbing", "None",       "Ultimate"]))
    createLeader(newLeader: try! Leader(fName: "Ryan", lName: "Reynolds", cabin: "3", senior: false,
                                        skills: ["Wall Climbing", "None",          "Pelletry",   "Wall Climbing"]))
    createLeader(newLeader: try! Leader(fName: "Hilary", lName: "Clinton", cabin: "A", senior: true,
                                        skills: ["Wall Climbing", "None",          "Pelletry",   "Archery"]))
    createLeader(newLeader: try! Leader(fName: "Doja", lName: "Cat", cabin: "A", senior: false,
                                        skills: ["Archery",       "None",          "Backcountry","Archery"]))
    createLeader(newLeader: try! Leader(fName: "Greta", lName: "Thunberg", cabin: "B", senior: true,
                                        skills: ["None",          "Archery",       "Backcountry","Backcountry"]))
    createLeader(newLeader: try! Leader(fName: "Nikki", lName: "Minaj", cabin: "B", senior: false,
                                        skills: ["Pelletry",      "Pelletry",      "None","None"]))
    createLeader(newLeader: try! Leader(fName: "Michelle", lName: "Obama", cabin: "C", senior: true,
                                        skills: ["None",          "Ultimate",      "Ultimate",   "Wall Climbing"]))
    createLeader(newLeader: try! Leader(fName: "Celine", lName: "Dion", cabin: "C", senior: false,
                                        skills: ["None",          "Wall Climbing","Ultimate",    "Ultimate"]))
}
