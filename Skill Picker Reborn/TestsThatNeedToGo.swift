//
//  TestsThatNeedToGo.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import Foundation

let fooSkills = ["Archery","Backcountry","Pelletry","Ultimate","Crafts","Drama"]
var fooCampers = [
    try! Camper(fName: "Joe", lName: "Biden", cabin: "1", preferredSkills: fooSkills),
    try! Camper(fName: "Donald", lName: "Trump", cabin: "2", preferredSkills: fooSkills),
    try! Camper(fName: "Snoop", lName: "Dogg", cabin: "2", preferredSkills: fooSkills),
    try! Camper(fName: "Hilary", lName: "Clinton", cabin: "A", preferredSkills: fooSkills),
    try! Camper(fName: "Doja", lName: "Cat", cabin: "A", preferredSkills: fooSkills),
]

var fooLeaders = [
    try! Leader(fName: "Dirty", lName: "Harry", cabin: "1", senior: true),
    try! Leader(fName: "Hugh", lName: "Jazz", cabin: "1", senior: false),
    try! Leader(fName: "Peter", lName: "Griffin", cabin: "2", senior: true),
    try! Leader(fName: "Mike", lName: "Ox", cabin: "2", senior: false),
    try! Leader(fName: "Lois", lName: "Griffin", cabin: "A", senior: true),
    try! Leader(fName: "Anna", lName: "Borshin", cabin: "A", senior: false)
]
var nullSenior = try! Leader(fName: "Null", lName: "Null", cabin: "Unassigned", senior: true)
var nullJunior = try! Leader(fName: "Null", lName: "Null", cabin: "Unassigned", senior: false)

var fooCabins = [
    "Unassigned": try! Cabin(name: "Unassigned", senior: nullSenior, junior: nullJunior, campers: []),
    "1": try! Cabin(name: "1", senior: fooLeaders[0], junior: fooLeaders[1], campers: [fooCampers[0]]),
    "2": try! Cabin(name: "2", senior: fooLeaders[2], junior: fooLeaders[3], campers: [fooCampers[1],fooCampers[2]]),
    "A": try! Cabin(name: "A", senior: fooLeaders[4], junior: fooLeaders[5], campers: [fooCampers[3],fooCampers[4]])
]

let validCabins: [String] = ["Unassigned","A","1","2"]
//["Unassigned","A","B","C","D","E","F","1","2","3","4","5"]

enum Flavor: String, CaseIterable, Identifiable {
    case chocolate, vanilla, strawberry
    var id: Self {
        self
    }
}
