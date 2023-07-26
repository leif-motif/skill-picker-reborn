//
//  SkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct SkillView: View {
    @State private var selectedSkill: String = "None"
    @State private var selectedPeriod: Int = 0
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var selectedLeader = Set<Leader.ID>()
    @State private var camperSortOrder = [KeyPathComparator(\Camper.lName)]
    @State private var leaderSortOrder = [KeyPathComparator(\Leader.lName)]
    var body: some View {
        VStack {
            Text("Leaders")
                .font(.title)
                .bold()
            Table((fooSkills[selectedSkill]!.leaders[selectedPeriod]), sortOrder: $leaderSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .onChange(of: camperSortOrder){
                fooSkills[selectedSkill]!.periods[selectedPeriod].sort(using: $0)
            }
            Text("Campers")
                .font(.title)
                .bold()
            Table((fooSkills[selectedSkill]!.periods[selectedPeriod]), sortOrder: $camperSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .onChange(of: camperSortOrder){
                fooSkills[selectedSkill]!.periods[selectedPeriod].sort(using: $0)
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Skill")
            Button {
                
            } label: {
                Image(systemName: "note.text.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Fanatic")
            Button {
                
            } label: {
                Image(systemName: "calendar.badge.minus")
                    .foregroundColor(Color(.systemRed))
            }
            .help("Remove Skill/Fanatic")
            Button {
                
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Skill Schedule")
            Picker("Skill", selection: $selectedSkill){
                ForEach(Array(fooSkills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Picker("Period", selection: $selectedPeriod){
                Text("Skill 1").tag(0)
                Text("Skill 2").tag(1)
                Text("Skill 3").tag(2)
                Text("Skill 4").tag(3)
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
