/*
 * SkillView.swift
 * This file is part of Skill Picker Reborn
 *
 * Copyright (C) 2024 Ranger Lake Bible Camp
 *
 * Skill Picker Reborn is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Skill Picker Reborn is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Skill Picker Reborn; if not, see <https://www.gnu.org/licenses/>.
 */

import SwiftUI

struct SkillView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var selectedLeader = Set<Leader.ID>()
    @State private var csvInput: [Substring] = [""]
    @State private var csvExport = ""
    @State private var showFanaticCsvExporter = false
    @State private var showSkillCsvExporter = false
    @State private var addSkillSheet = false
    @State private var addFanaticSheet = false
    @State private var editSkillSheet = false
    @State private var editFanaticSheet = false
    @State private var assignSkillLeaderSheet = false
    @State private var assignSkillCamperSheet = false
    @State private var camperInfoSheet = false
    @State private var leaderInfoSheet = false
    @State private var importSkillSheet = false
    @State private var exportSkillAlert = false
    @State private var search = ""
    var body: some View {
        VStack {
            Text("Leaders")
                .font(.title)
                .bold()
                .padding(.top, 10)
            Table(data.skills[data.selectedSkill]!.leaders[data.selectedPeriod], selection: $selectedLeader, sortOrder: $data.skillLeaderSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .frame(height: 85)
            .onChange(of: data.skillLeaderSortOrder){
                data.objectWillChange.send()
                data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Leader.ID.self) { items in
                if items.isEmpty {
                    Button {
                        assignSkillLeaderSheet.toggle()
                    } label: {
                        Label("Assign Leader to Skill...", systemImage: "plus")
                    }
                    .disabled(data.leaders.count == data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count)
                } else if items.count == 1 {
                    Button {
                        if(selectedLeader.count == 1){
                            leaderInfoSheet.toggle()
                        }
                    } label: {
                        Label("Info/Edit...", systemImage: "pencil.line")
                    }
                    Button(role: .destructive) {
                        if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: data.selectedSkill, data: data)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    .disabled(data.selectedSkill == "None")
                    Button(role: .destructive) {
                        deleteLeader(leaderSelection: selectedLeader, data: data)
                        data.objectWillChange.send()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: data.selectedSkill, data: data)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    .disabled(data.selectedSkill == "None")
                    Button(role: .destructive) {
                        deleteLeader(leaderSelection: selectedLeader, data: data)
                        data.objectWillChange.send()
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
            //for some reason, empty selections no longer work, so a second contextMenu must be added.
            //trillion dollar company right here, folks. trillion dollar company.
            .contextMenu(){
                Button {
                    assignSkillLeaderSheet.toggle()
                } label: {
                    Label("Assign Leader to Skill...", systemImage: "plus")
                }
                .disabled(data.leaders.count == data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count)
            }
            @State var currentSkillCount = data.skills[data.selectedSkill]!.periods[data.selectedPeriod].count
            @State var currentSkillMax = data.skills[data.selectedSkill]!.maximums[data.selectedPeriod]
            Text("Campers ("+String(currentSkillCount)+"/"+String(currentSkillMax)+")")
                .font(.title)
                .bold()
                .foregroundColor(currentSkillCount > currentSkillMax ? Color(.systemRed) : Color.primary)
            Table(data.skills[data.selectedSkill]!.periods[data.selectedPeriod], selection: $selectedCamper, sortOrder: $data.skillCamperSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
            }
            .onChange(of: data.skillCamperSortOrder){
                data.objectWillChange.send()
                data.skills[data.selectedSkill]!.periods[data.selectedPeriod].sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
                if items.isEmpty {
                    Button {
                        assignSkillCamperSheet.toggle()
                    } label: {
                        Label("Assign Camper to Skill...", systemImage: "plus")
                    }
                } else if items.count == 1 {
                    Button {
                        if(selectedCamper.count == 1){
                            camperInfoSheet.toggle()
                        }
                    } label: {
                         Label("Info/Edit...", systemImage: "pencil.line")
                    }
                    Button(role: .destructive) {
                        if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeCamperFromFanatic(camperSelection: selectedCamper, fanaticName: data.selectedSkill, newSixthPreferredSkill: "None", data: data)
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    .disabled(data.selectedSkill == "None")
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper, data: data)
                        data.objectWillChange.send()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeCamperFromFanatic(camperSelection: selectedCamper, fanaticName: data.selectedSkill, newSixthPreferredSkill: "None", data: data)
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                        }
                        data.objectWillChange.send()
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    .disabled(data.selectedSkill == "None")
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper, data: data)
                        data.objectWillChange.send()
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
            .contextMenu(){
                Button {
                    assignSkillCamperSheet.toggle()
                } label: {
                    Label("Assign Camper to Skill...", systemImage: "plus")
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
            .sheet(isPresented: $addSkillSheet){
            } content: {
                try! ModifySkillView()
            }
            Button {
                addFanaticSheet.toggle()
            } label: {
                Image(systemName: "note.text.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Fanatic")
            .sheet(isPresented: $addFanaticSheet){
            } content: {
                ModifyFanaticView()
            }
            Button {
                data.objectWillChange.send()
                if(data.fanatics.keys.contains(data.selectedSkill)){
                    try! deleteFanatic(fanaticName: data.selectedSkill, data: data)
                } else {
                    try! deleteSkill(skillName: data.selectedSkill, data: data)
                }
                data.selectedSkill = "None"
            } label: {
                Image(systemName: "calendar.badge.minus")
                    .foregroundColor(data.selectedSkill == "None" ? Color(.systemGray) : Color(.systemRed))
            }
            .help("Remove Skill/Fanatic")
            .disabled(data.selectedSkill == "None")
            Button {
                if(data.fanatics.keys.contains(data.selectedSkill)){
                    editFanaticSheet.toggle()
                } else {
                    editSkillSheet.toggle()
                }
            } label: {
                Image(systemName: "pencil.line")
                    .foregroundColor(data.selectedSkill == "None" ? Color(.systemGray) : Color(.systemOrange))
            }
            .disabled(data.selectedSkill == "None")
            .sheet(isPresented: $editFanaticSheet, onDismiss: {
                data.objectWillChange.send()
            }, content: {
                ModifyFanaticView(targetFanatic: data.selectedSkill)
            })
            .sheet(isPresented: $editSkillSheet, onDismiss: {
                data.objectWillChange.send()
            }, content: {
                try! ModifySkillView(targetSkill: data.selectedSkill)
            })
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.allowedContentTypes = [.csv]
                if panel.runModal() == .OK {
                    do {
                        csvInput = try String(contentsOf: panel.url!).lines
                        data.importSkillList = skillListFromCSV(csv: csvInput)
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
            .sheet(isPresented: $importSkillSheet, onDismiss: {
                if(data.isImporting){
                    cabinsFromCSV(csv: csvInput, data: data)
                    try! campersFromCSV(csv: csvInput, data: data)
                    data.isImporting = false
                }
            }, content: {
                try! ImportSkillView(data: data)
            })
            Button {
                if(data.fanatics.keys.contains(data.selectedSkill)){
                    var p: Int?
                    for i in 0...3 {
                        if(data.fanatics[data.selectedSkill]!.activePeriods[i]){
                            p = i
                            break
                        }
                    }
                    if(data.skills[data.selectedSkill]!.periods[p!].count != 0 && data.skills[data.selectedSkill]!.leaders[p!].count != 0){
                        csvExport = fanaticListToCSV(fanaticName: data.selectedSkill, data: data)
                        showFanaticCsvExporter.toggle()
                    } else {
                        exportSkillAlert.toggle()
                    }
                } else {
                    if(data.skills[data.selectedSkill]!.periods[data.selectedPeriod].count != 0 && data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count != 0){
                        csvExport = skillListToCSV(skillName: data.selectedSkill, skillPeriod: data.selectedPeriod, data: data)
                        showSkillCsvExporter.toggle()
                    } else {
                        exportSkillAlert.toggle()
                    }
                }
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Skill Schedule")
            .fileExporter(isPresented: $showFanaticCsvExporter, document: CSVFile(initialText: csvExport),
                          contentType: .csv, defaultFilename: data.selectedSkill) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .alert(isPresented: $exportSkillAlert) {
                Alert(title: Text("Error!"),
                      message: Text("Cannot export skill; there must be both leaders and campers assigned to the skill for export."),
                      dismissButton: .default(Text("Dismiss")))
            }
            Picker("Skill", selection: $data.selectedSkill){
                ForEach(Array(data.skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .frame(width: 120)
            Picker("Period", selection: $data.selectedPeriod){
                ForEach(0...3, id: \.self){
                    Text("Skill "+String($0+1)).tag($0)
                }
            }
            //TODO: implement search bar
            TextField("Search...", text: $search)
                .frame(width: 100)
                .disabled(true)
        }
        .sheet(isPresented: $camperInfoSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            try! CamperInfoView(camperSelection: selectedCamper)
        })
        .sheet(isPresented: $leaderInfoSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            try! LeaderInfoView(leaderSelection: selectedLeader)
        })
        .sheet(isPresented: $assignSkillLeaderSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            AssignSkillLeaderView(targetSkill: data.selectedSkill, skillPeriod: data.selectedPeriod)
        })
        .sheet(isPresented: $assignSkillCamperSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            AssignSkillCamperView(targetSkill: data.selectedSkill, skillPeriod: data.selectedPeriod)
        })
        //Somehow, you can't have more than one file exporter in a single view.
        //WHY?
        .fileExporter(isPresented: $showSkillCsvExporter, document: CSVFile(initialText: csvExport),
                      contentType: .csv, defaultFilename: data.selectedSkill+" - Skill "+String(data.selectedPeriod+1)) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

/*this is WAY too complex for previewing
struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
            .environmentObject(CampData())
    }
}*/
