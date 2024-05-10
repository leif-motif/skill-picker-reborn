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
    @State private var camperEditPass: HumanSelection<Camper>?
    @State private var camperDestPass: HumanSelection<Camper>?
    @State private var selectedLeader = Set<Leader.ID>()
    @State private var leaderEditPass: HumanSelection<Leader>?
    @State private var leaderDestPass: HumanSelection<Leader>?
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
    @State private var removeCamperConfirm = false
    @State private var removeLeaderConfirm = false
    @State private var deleteCamperConfirm = false
    @State private var deleteLeaderConfirm = false
    @State private var deleteSkillConfirm = false
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
                let leaderSelectionUnion = selectedLeader.union(items)
                if(leaderSelectionUnion.isEmpty){
                    Button {
                        assignSkillLeaderSheet.toggle()
                    } label: {
                        Label("Assign Leader to Skill...", systemImage: "plus")
                    }
                    .disabled(data.leaders.count == data.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count)
                } else if(leaderSelectionUnion.count == 1){
                    Button {
                        leaderEditPass = HumanSelection(selection: leaderSelectionUnion)
                    } label: {
                        Label("Info/Edit...", systemImage: "pencil.line")
                    }
                }
                if(leaderSelectionUnion.count > 0){
                    Button(role: .destructive) {
                        #warning("TODO: enable deletion and removal of leaders")
                        /*if(data.fanatics.keys.contains(data.selectedSkill)){
                            for leaderID in selectedLeader.union(items){
                                try! removeLeaderFromFanatic(leaderID: leaderID, fanaticName: data.selectedSkill, data: data)
                            }
                        } else {
                            for leaderID in selectedLeader.union(items){
                                try! removeLeaderFromSkill(leaderID: leaderID, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                            }
                        }
                        data.objectWillChange.send()*/
                    } label: {
                        if(leaderSelectionUnion.count == 1){
                            Label("Remove", systemImage: "trash")
                        } else {
                            Label("Remove Selection", systemImage: "trash")
                        }
                    }
                    .disabled(data.selectedSkill == "None")
                    Button(role: .destructive) {
                        /*for leaderID in selectedLeader.union(items) {
                            deleteLeader(leaderID: leaderID, data: data)
                        }
                        data.objectWillChange.send()*/
                    } label: {
                        if(leaderSelectionUnion.count == 1){
                            Label("Delete", systemImage: "trash")
                        } else {
                            Label("Delete Selection", systemImage: "trash")
                        }
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
                let camperSelectionUnion = selectedCamper.union(items)
                if(camperSelectionUnion.isEmpty){
                    Button {
                        assignSkillCamperSheet.toggle()
                    } label: {
                        Label("Assign Camper to Skill...", systemImage: "plus")
                    }
                } else if(camperSelectionUnion.count == 1){
                    Button {
                        camperEditPass = HumanSelection(selection: camperSelectionUnion)
                    } label: {
                         Label("Info/Edit...", systemImage: "pencil.line")
                    }
                }
                if(camperSelectionUnion.count > 0){
                    Button(role: .destructive) {
                        camperDestPass = HumanSelection(selection: camperSelectionUnion)
                        removeCamperConfirm.toggle()
                    } label: {
                        if(camperSelectionUnion.count == 1){
                            Label("Remove", systemImage: "trash")
                        } else {
                            Label("Remove Selection", systemImage: "trash")
                        }
                    }
                    .disabled(data.selectedSkill == "None")
                    Button(role: .destructive) {
                        camperDestPass = HumanSelection(selection: camperSelectionUnion)
                        deleteCamperConfirm.toggle()
                    } label: {
                        if(camperSelectionUnion.count == 1){
                            Label("Delete", systemImage: "trash")
                        } else {
                            Label("Delete Selection", systemImage: "trash")
                        }
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
            .confirmationDialog("Confirm Removal", isPresented: $removeCamperConfirm, presenting: camperDestPass){ p in
                Button(role: .cancel){
                } label: {
                    Text("Cancel")
                }
                Button(role: .destructive){
                    //remove from skill
                    if(data.fanatics.keys.contains(data.selectedSkill)){
                        for camperID in p.selection {
                            try! removeCamperFromFanatic(camperID: camperID, fanaticName: data.selectedSkill, newSixthPreferredSkill: "None", data: data)
                        }
                    } else {
                        for camperID in p.selection {
                            try! removeCamperFromSkill(camperID: camperID, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
                        }
                    }
                    camperDestPass = nil
                    selectedCamper = []
                    data.objectWillChange.send()
                } label: {
                    Text("Remove")
                }
            } message: { p in
                if(p.selection.count == 1){
                    Text("Are you sure you want to remove the selected camper from the \(data.fanatics.keys.contains(data.selectedSkill) ? "fanatic" : "skill")?")
                } else {
                    Text("Are you sure you want to remove multiple campers from the \(data.fanatics.keys.contains(data.selectedSkill) ? "fanatic" : "skill")?")
                }
            }
            .confirmationDialog("Confirm Deletion", isPresented: $deleteCamperConfirm, presenting: camperDestPass){ p in
                Button(role: .cancel){
                } label: {
                    Text("Cancel")
                }
                Button(role: .destructive){
                    for camperID in p.selection {
                        deleteCamper(camperID: camperID, data: data)
                    }
                    camperDestPass = nil
                    selectedCamper = []
                } label: {
                    Text("Remove")
                }
            } message: { p in
                if(p.selection.count == 1){
                    Text("Are you sure you want to delete the selected camper?")
                } else {
                    Text("Are you sure you want to delete "+String(p.selection.count)+" campers?")
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
            #warning("TODO: implement search bar")
            TextField("Search...", text: $search)
                .frame(width: 100)
                .disabled(true)
        }
        .sheet(item: $camperEditPass, onDismiss: {
            data.objectWillChange.send()
            selectedCamper = []
        }, content: { x in
            CamperInfoView(camperID: x.selection.first!)
        })
        .sheet(item: $leaderEditPass, onDismiss: {
            data.objectWillChange.send()
            selectedLeader = []
        }, content: { x in
            LeaderInfoView(leaderID: x.selection.first!)
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
