//
//  SkillView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

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
    @State private var assignSkillLeaderSheet = false
    @State private var assignSkillCamperSheet = false
    @State private var addFanaticSheet = false
    @State private var assignFanaticLeaderSheet = false
    @State private var assignFanaticCamperSheet = false
    @State private var importSkillSheet = false
    @State private var skillErrorAlert = false
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
                        if(data.skills[data.selectedSkill]!.maximums[data.selectedPeriod] == 0 || data.leaders.count == 0){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(data.selectedSkill)){
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
                        if(data.selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: data.selectedSkill, data: data)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
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
                        if(data.selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeLeaderFromFanatic(leaderSelection: selectedLeader, fanaticName: data.selectedSkill, data: data)
                        } else {
                            try! removeLeaderFromSkill(leaderSelection: selectedLeader, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
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
            @State var currentSkillCount = data.skills[data.selectedSkill]!.periods[data.selectedPeriod].count
            @State var currentSkillMax = data.skills[data.selectedSkill]!.maximums[data.selectedPeriod]
            Text("Campers ("+String(currentSkillCount)+"/"+String(currentSkillMax)+")")
                .font(.title)
                .bold()
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
                        if(data.skills[data.selectedSkill]!.periods[data.selectedPeriod].count >= data.skills[data.selectedSkill]!.maximums[data.selectedPeriod] || data.campers.count == 0){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(data.selectedSkill)){
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
                        if(data.selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeCamperFromFanatic(camperSelection: selectedCamper, fanaticName: data.selectedSkill, newSixthPreferredSkill: "None", data: data)
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
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
                        if(data.selectedSkill == "None"){
                            skillErrorAlert.toggle()
                        } else if(data.fanatics.keys.contains(data.selectedSkill)){
                            try! removeCamperFromFanatic(camperSelection: selectedCamper, fanaticName: data.selectedSkill, newSixthPreferredSkill: "None", data: data)
                        } else {
                            try! removeCamperFromSkill(camperSelection: selectedCamper, skillName: data.selectedSkill, period: data.selectedPeriod, data: data)
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
                if(data.selectedSkill == "None"){
                    skillErrorAlert.toggle()
                } else {
                    data.objectWillChange.send()
                    if(data.fanatics.keys.contains(data.selectedSkill)){
                        try! deleteFanatic(fanaticName: data.selectedSkill, data: data)
                    } else {
                        try! deleteSkill(skillName: data.selectedSkill, data: data)
                    }
                    data.selectedSkill = "None"
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
            .frame(width: 170)
            Picker("Period", selection: $data.selectedPeriod){
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
            AssignSkillLeaderView(targetSkill: data.selectedSkill, skillPeriod: data.selectedPeriod)
        }
        .sheet(isPresented: $assignSkillCamperSheet) {
        } content: {
            AssignSkillCamperView(targetSkill: data.selectedSkill, skillPeriod: data.selectedPeriod)
        }
        .sheet(isPresented: $addFanaticSheet) {
        } content: {
            AddFanaticView()
        }
        .sheet(isPresented: $assignFanaticLeaderSheet) {
        } content: {
            AssignFanaticLeaderView(targetFanatic: data.selectedSkill)
        }
        .sheet(isPresented: $assignFanaticCamperSheet) {
        } content: {
            AssignFanaticCamperView(targetFanatic: data.selectedSkill)
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

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
    }
}
