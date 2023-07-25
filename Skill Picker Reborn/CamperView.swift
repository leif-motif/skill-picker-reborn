//
//  CamperView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import SwiftUI

let fooSkills = ["Archery","Backcountry","Pelletry","Ultimate","Crafts","Drama"]
var campers = [
    try! Camper(fName: "Joe", lName: "Biden", cabin: "1", preferredSkills: fooSkills),
    try! Camper(fName: "Donald", lName: "Trump", cabin: "2", preferredSkills: fooSkills),
    try! Camper(fName: "Hilary", lName: "Clinton", cabin: "F", preferredSkills: fooSkills),
    try! Camper(fName: "Doja", lName: "Cat", cabin: "A", preferredSkills: fooSkills),
    try! Camper(fName: "Snoop", lName: "Dogg", cabin: "3", preferredSkills: fooSkills)
]

struct CamperView: View {
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    var body: some View {
        VStack(){
            Table(campers, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
                TableColumn("Skill 1",value: \.skillOne)
                TableColumn("Skill 2",value: \.skillTwo)
                TableColumn("Skill 3",value: \.skillThree)
                TableColumn("Skill 4",value: \.skillFour)
            }
            .onChange(of: sortOrder){
                campers.sort(using: $0)
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "doc")
            }
            .help("Select File")
            Button {
                
            } label: {
                Image(systemName:"person.badge.plus")
            }
            .help("Add Camper")
            Button {
                
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
            }
            .help("Export Schedules")
            TextField("Search", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
        }
    }
}


struct CamperView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
