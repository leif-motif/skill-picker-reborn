//
//  SkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct SkillView: View {
    @State private var selectedSkill: String = "None"
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    var body: some View {
        VStack {
            //ForEach(fooSkills){
                
            //}
            Table(fooCampers, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "rectangle.stack.badge.plus")
            }
            .help("Add Skill")
            Button {
                
            } label: {
                Image(systemName: "rectangle.badge.plus")
            }
            .help("Add Fanatic")
            Picker("Skill", selection: $selectedSkill) {
                Text("None").tag("None")
                Text("Backcountry").tag("Backcountry")
                Text("Ultimate").tag("Ultimate")
            }
            TextField(" This search bar doesn't work. ", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
        }
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
