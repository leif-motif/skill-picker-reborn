//
//  SkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct SkillView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedSkill: String = "None"
    @State private var selectedPeriod: Int = 0
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var selectedLeader = Set<Leader.ID>()
    @State private var camperSortOrder = [KeyPathComparator(\Camper.lName)]
    @State private var leaderSortOrder = [KeyPathComparator(\Leader.lName)]
    @State private var csvInput: [Substring] = [""]
    @State private var showSkillCsvExporter = false
    @State private var addSkillSheet = false
    @State private var assignSkillLeaderSheet = false
    @State private var assignSkillCamperSheet = false
    @State private var addFanaticSheet = false
    @State private var assignFanaticLeaderSheet = false
    @State private var assignFanaticCamperSheet = false
    @State private var importSkillSheet = false
    @State private var skillErrorAlert = false
    @State private var search = ""
    var body: some View {
        VStack {
            Text("Leaders")
                .font(.title)
                .bold()
                .padding(.top, 10)
            Table(data.skills[selectedSkill]!.leaders[selectedPeriod], selection: $selectedLeader, sortOrder: $leaderSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .frame(height: 85)
            .onChange(of: leaderSortOrder){
                data.objectWillChange.send()
                data.skills[selectedSkill]!.leaders[selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Leader.ID.self) { items in
                if items.isEmpty {
                    Button {
                        if(data.skills[selectedSkill]!.maximums[selectedPeriod] == 0 || data.leaders.count == 0){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(selectedSkill)){
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
                        } else if(data.fanatics.keys.contains(selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: selectedSkill, data: data)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: selectedSkill, period: selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteLeader(leaderSelection: selectedLeader, data: data)
                        data.objectWillChange.send()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        if(selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: selectedSkill, data: data)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: selectedSkill, period: selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteLeader(leaderSelection: selectedLeader, data: data)
                        data.objectWillChange.send()
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
            @State var currentSkillCount = data.skills[selectedSkill]!.periods[selectedPeriod].count
            @State var currentSkillMax = data.skills[selectedSkill]!.maximums[selectedPeriod]
            Text("Campers ("+String(currentSkillCount)+"/"+String(currentSkillMax)+")")
                .font(.title)
                .bold()
            Table(data.skills[selectedSkill]!.periods[selectedPeriod], selection: $selectedCamper, sortOrder: $camperSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .onChange(of: camperSortOrder){
                data.objectWillChange.send()
                data.skills[selectedSkill]!.periods[selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
                if items.isEmpty {
                    Button {
                        if(data.skills[selectedSkill]!.periods[selectedPeriod].count >= data.skills[selectedSkill]!.maximums[selectedPeriod] || data.campers.count == 0){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(selectedSkill)){
                            assignFanaticCamperSheet.toggle()
                        } else {
                            assignSkillCamperSheet.toggle()
                        }
                        data.objectWillChange.send()
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
                        } else if(data.fanatics.keys.contains(selectedSkill)){
                            try! removeCamperFromFanatic(camperSelection: selectedCamper, fanaticName: selectedSkill, newSixthPreferredSkill: "None", data: data)
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: selectedSkill, period: selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper, data: data)
                        data.objectWillChange.send()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        if(selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(selectedSkill)){
                            try! removeCamperFromFanatic(camperSelection: selectedCamper, fanaticName: selectedSkill, newSixthPreferredSkill: "None", data: data)
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: selectedSkill, period: selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper, data: data)
                        data.objectWillChange.send()
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
                    data.objectWillChange.send()
                    if(data.fanatics.keys.contains(selectedSkill)){
                        try! deleteFanatic(fanaticName: selectedSkill, data: data)
                    } else {
                        try! deleteSkill(skillName: selectedSkill, data: data)
                    }
                    selectedSkill = "None"
                }
            } label: {
                Image(systemName: "calendar.badge.minus")
                    .foregroundColor(Color(.systemRed))
            }
            .help("Remove Skill/Fanatic")
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.allowedContentTypes = [.csv]
                if panel.runModal() == .OK {
                    do {
                        csvInput = try String(contentsOf: panel.url!).lines
                        importSkillList = skillListFromCSV(csv: csvInput)
                        importSkillSheet.toggle()
                    } catch {
                        //I have really no idea what this does.
                        //It was whining about some kind of warning earlier? Wrapped \/ THAT part in String() and it shut up so idk.
                        assertionFailure("Failed reading from URL: \(String(describing: panel.url)), Error: " + error.localizedDescription)
                    }
                }
            } label: {
                Image(systemName: "arrow.down.doc")
                    .foregroundColor(Color(.systemBlue))
            }
            .help("Import CSV")
            Button {
                showSkillCsvExporter.toggle()
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Skill Schedule")
            .fileExporter(isPresented: $showSkillCsvExporter, document: CSVFile(initialText: try! skillListToCSV(skillName: selectedSkill,
                                                                                                                 skillPeriod: selectedPeriod,
                                                                                                                 data: data)),
                          contentType: .csv, defaultFilename: selectedSkill+" - Skill"+String(selectedPeriod+1)) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            Picker("Skill", selection: $selectedSkill){
                ForEach(Array(data.skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .frame(width: 170)
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
        .sheet(isPresented: $importSkillSheet, onDismiss: {
            if(isImporting){
                cabinsFromCSV(csv: csvInput, data: data)
                try! campersFromCSV(csv: csvInput, data: data)
                isImporting = false
            }
        }, content: {
            try! ImportSkillView()
        })
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
