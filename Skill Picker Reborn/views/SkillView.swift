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
    @State private var addFanaticSheet = false
    @State private var noneSkillAlert = false
    @State private var search = ""
    var body: some View {
        VStack {
            Text("Leaders")
                .font(.title)
                .bold()
                .padding(.top, 10)
            Table((fooSkills[selectedSkill]!.leaders[selectedPeriod]), selection: $selectedLeader, sortOrder: $leaderSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .frame(height: 85)
            .onChange(of: leaderSortOrder){
                fooSkills[selectedSkill]!.leaders[selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Leader.ID.self) { items in
                if items.isEmpty {
                    Button {
                        if(fooFanatics.keys.contains(selectedSkill)){
                            //assign leader to fanatic
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
                        //remove leader from skill
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        //delete leader
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        //remove leaders from skill
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        //delete leaders
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
            @State var currentSkillCount = fooSkills[selectedSkill]!.periods[selectedPeriod].count
            @State var currentSkillMax = fooSkills[selectedSkill]!.maximums[selectedPeriod]
            Text("Campers ("+String(currentSkillCount)+"/"+String(currentSkillMax)+")")
                .font(.title)
                .bold()
            Table((fooSkills[selectedSkill]!.periods[selectedPeriod]), selection: $selectedCamper, sortOrder: $camperSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .onChange(of: camperSortOrder){
                fooSkills[selectedSkill]!.periods[selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
                if items.isEmpty {
                    Button {
                        //assign camper
                    } label: {
                        Label("Assign Camper to Skill...", systemImage: "plus")
                    }
                } else if items.count == 1 {
                    /*Button {
                     
                     } label: {
                     Label("Info/Edit...", systemImage: "pencil.line")
                     }*/
                    Button(role: .destructive) {
                        //remove camper from skill
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
                        //remove campers from skill
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
                    noneSkillAlert.toggle()
                } else {
                    if(fooFanatics.keys.contains(selectedSkill)){
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
        .sheet(isPresented: $addFanaticSheet) {
        } content: {
            AddFanaticView()
        }
        .alert(isPresented: $noneSkillAlert) {
            Alert(title: Text("Error!"),
                  message: Text("Cannot delete the \"None\" skill."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
