//
//  ContentView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import SwiftUI

let campers = [
    try! Camper(fName: "Joe", lName: "Biden", cabin: "1", preferredSkills: ["Archery","Backcountry","Pelletry","Ultimate","Crafts","Drama"]),
    try! Camper(fName: "Donald", lName: "Trump", cabin: "2", preferredSkills: ["Ultimate","Pedal Karts","Horses","Canoeing","Hockey",""])
]

struct ContentView: View {
    var body: some View {
        VStack(){
            HStack(){
                Button("Select File"){
                    
                }
                Button("Add Camper"){
                    
                }
                Button("Sort"){
                    
                }
                Button("Export Schedules"){
                    
                }
                .padding([.bottom,.top])
            }
            Table(campers){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
                TableColumn("Skill 1",value: \.skillOne)
                TableColumn("Skill 2",value: \.skillTwo)
                TableColumn("Skill 3",value: \.skillThree)
                TableColumn("Skill 4",value: \.skillFour)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
