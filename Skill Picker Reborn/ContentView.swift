//
//  ContentView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import SwiftUI

var campers = [
    try! Camper(fName: "Joe", lName: "Biden", cabin: "1", preferredSkills: ["Archery","Backcountry","Pelletry","Ultimate","Crafts","Drama"]),
    try! Camper(fName: "Donald", lName: "Trump", cabin: "2", preferredSkills: ["Ultimate","Pedal Karts","Horses","Canoeing","Hockey",""])
]

struct ContentView: View {
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    var body: some View {
        VStack(){
            HStack(){
                Button("Select File"){
                    
                }
                Button("Add Camper"){
                    
                }
                Button("Export Schedules"){
                    
                }
                .padding([.bottom,.top])
            }
            HStack(){
                Text("Search")
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            }
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
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
