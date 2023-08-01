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
    @State private var addSkillSheet = false
    @State private var assignSkillLeaderSheet = false
    @State private var assignSkillCamperSheet = false
    @State private var addFanaticSheet = false
    @State private var assignFanaticLeaderSheet = false
    @State private var assignFanaticCamperSheet = false
    @State private var skillErrorAlert = false
    @State private var search = ""
    var body: some View {
        VStack {
            Text("Leaders")
                .font(.title)
                .bold()
                .padding(.top, 10)
            Table(skills[selectedSkill]!.leaders[selectedPeriod], selection: $selectedLeader, sortOrder: $leaderSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .frame(height: 85)
            .onChange(of: leaderSortOrder){
                skills[selectedSkill]!.leaders[selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Leader.ID.self) { items in
                if items.isEmpty {
                    Button {
                        if(skills[selectedSkill]!.maximums[selectedPeriod] == 0){
                            skillErrorAlert.toggle()
                        } else if(fanatics.keys.contains(selectedSkill)){
                            assignFanaticLeaderSheet.toggle()
                        } else {
                            assignSkillLeaderSheet.toggle()
                        }
                    } label: {
                        Label("Assign Leader to Skill...", systemImage: "plus")
                    }
                } else if items.count == 1 {
                    /*Button {
                     
                     } label: {
                     Label("Info/Edit...", systemImage: "pencil.line")
                     }*/
                    Button(role: .destructive) {
                        if(selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(fanatics.keys.contains(selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: selectedSkill)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: selectedSkill, period: selectedPeriod)
                        }
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteLeader(leaderSelection: selectedLeader)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        if(selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(fanatics.keys.contains(selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: selectedSkill)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: selectedSkill, period: selectedPeriod)
                        }
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteLeader(leaderSelection: selectedLeader)
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
            @State var currentSkillCount = skills[selectedSkill]!.periods[selectedPeriod].count
            @State var currentSkillMax = skills[selectedSkill]!.maximums[selectedPeriod]
            Text("Campers ("+String(currentSkillCount)+"/"+String(currentSkillMax)+")")
                .font(.title)
                .bold()
            Table(skills[selectedSkill]!.periods[selectedPeriod], selection: $selectedCamper, sortOrder: $camperSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .onChange(of: camperSortOrder){
                skills[selectedSkill]!.periods[selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
                if items.isEmpty {
                    Button {
                        if(skills[selectedSkill]!.periods[selectedPeriod].count >= skills[selectedSkill]!.maximums[selectedPeriod]){
                            skillErrorAlert.toggle()
                        } else if(fanatics.keys.contains(selectedSkill)){
                            assignFanaticCamperSheet.toggle()
                        } else {
                            assignSkillCamperSheet.toggle()
                        }
                    } label: {
                        Label("Assign Camper to Skill...", systemImage: "plus")
                    }
                } else if items.count == 1 {
                    /*Button {
                     
                     } label: {
                     Label("Info/Edit...", systemImage: "pencil.line")
                     }*/
                    Button(role: .destructive) {
                        if(selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(fanatics.keys.contains(selectedSkill)){
                            //remove camper from fanatic
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: selectedSkill, period: selectedPeriod)
                        }
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        if(selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(fanatics.keys.contains(selectedSkill)){
                            //remove camper from fanatic
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: selectedSkill, period: selectedPeriod)
                        }
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper)
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
        }
        .toolbar {
            Button {
                addSkillSheet.toggle()
            } label: {
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Skill")
            Button {
                addFanaticSheet.toggle()
            } label: {
                Image(systemName: "note.text.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Fanatic")
            Button {
                if(selectedSkill == "None"){
                    skillErrorAlert.toggle()
                } else {
                    if(fanatics.keys.contains(selectedSkill)){
                        try! deleteFanatic(fanaticName: selectedSkill)
                    } else {
                        try! deleteSkill(skillName: selectedSkill)
                    }
                }
            } label: {
                Image(systemName: "calendar.badge.minus")
                    .foregroundColor(Color(.systemRed))
            }
            .help("Remove Skill/Fanatic")
            Button {
                //export schedule
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Skill Schedule")
            Picker("Skill", selection: $selectedSkill){
                ForEach(Array(skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            Picker("Period", selection: $selectedPeriod){
                ForEach(0...3, id: \.self){
                    Text("Skill "+String($0+1)).tag($0)
                }
            }
            TextField("Search...", text: $search)
                .frame(width: 100)
        }
        .sheet(isPresented: $addSkillSheet) {
        } content: {
            AddSkillView()
        }
        .sheet(isPresented: $assignSkillLeaderSheet) {
        } content: {
            AssignSkillLeaderView(targetSkill: selectedSkill, skillPeriod: selectedPeriod)
        }
        .sheet(isPresented: $assignSkillCamperSheet) {
        } content: {
            AssignSkillCamperView(targetSkill: selectedSkill, skillPeriod: selectedPeriod)
        }
        .sheet(isPresented: $addFanaticSheet) {
        } content: {
            AddFanaticView()
        }
        .sheet(isPresented: $assignFanaticLeaderSheet) {
        } content: {
            AssignFanaticLeaderView(targetFanatic: selectedSkill)
        }
        .sheet(isPresented: $assignFanaticCamperSheet) {
        } content: {
            AssignFanaticCamperView(targetFanatic: selectedSkill)
        }
        //Somehow, you can't have more than one alerts in a single view.
        //WHY?
        .alert(isPresented: $skillErrorAlert) {
            Alert(title: Text("Error!"),
                  message: Text("Cannot perform desired operation on skill."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
