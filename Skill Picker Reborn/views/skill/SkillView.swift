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
    @State private var csvExport = ""
    @State private var showFanaticCsvExporter = false
    @State private var showSkillCsvExporter = false
    @State private var addSkillSheet = false
    @State private var addFanaticSheet = false
    @State private var editSkillSheet = false
    @State private var editFanaticSheet = false
    @State private var deleteSkillConfirm = false
    @State private var importSkillSheet = false
    @State private var ignoreIdiotsConfirm = false
    @State private var search = ""
    var body: some View {
        VStack {
            SkillLeadersView(searchTerm: search)
            SkillCampersView(searchTerm: search)
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
                deleteSkillConfirm.toggle()
            } label: {
                Image(systemName: "calendar.badge.minus")
                    .foregroundColor(data.selectedSkill == "None" ? Color(.systemGray) : Color(.systemRed))
            }
            .help("Remove Skill/Fanatic")
            .disabled(data.selectedSkill == "None")
            Button {
                if(data.c.fanatics.keys.contains(data.selectedSkill)){
                    editFanaticSheet.toggle()
                } else {
                    editSkillSheet.toggle()
                }
            } label: {
                Image(systemName: "pencil.line")
                    .foregroundColor(data.selectedSkill == "None" ? Color(.systemGray) : Color(.systemOrange))
            }
            .confirmationDialog("Confirm Deletion", isPresented: $deleteSkillConfirm){
                Button(role: .cancel){
                } label: {
                    Text("Cancel")
                }
                Button(role: .destructive){
                    if(data.c.fanatics.keys.contains(data.selectedSkill)){
                        try! data.deleteFanatic(fanaticName: data.selectedSkill)
                    } else {
                        try! data.deleteSkill(skillName: data.selectedSkill)
                    }
                    data.selectedSkill = "None"
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("Are you sure you want to delete \(data.selectedSkill)?")
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
                data.importFromCSV()
            } label: {
                Image(systemName: "arrow.down.doc")
                    .foregroundColor(Color(.systemBlue))
            }
            .help("Import CSV")
            Button {
                if(data.c.fanatics.keys.contains(data.selectedSkill)){
                    var p: Int?
                    for i in 0...3 {
                        if(data.c.fanatics[data.selectedSkill]!.activePeriods[i]){
                            p = i
                            break
                        }
                    }
                    if(data.c.skills[data.selectedSkill]!.periods[p!].count != 0 && data.c.skills[data.selectedSkill]!.leaders[p!].count != 0){
                        csvExport = data.fanaticListToCSV(fanaticName: data.selectedSkill)
                        showFanaticCsvExporter.toggle()
                    } else {
                        data.genericErrorDesc = "Cannot export skill; there must be both leaders and campers assigned to the skill for export."
                        data.genericErrorAlert.toggle()
                    }
                } else {
                    if(data.c.skills[data.selectedSkill]!.periods[data.selectedPeriod].count != 0 && data.c.skills[data.selectedSkill]!.leaders[data.selectedPeriod].count != 0){
                        csvExport = data.skillListToCSV(skillName: data.selectedSkill, skillPeriod: data.selectedPeriod)
                        showSkillCsvExporter.toggle()
                    } else {
                        data.genericErrorDesc = "Cannot export skill; there must be both leaders and campers assigned to the skill for export."
                        data.genericErrorAlert.toggle()
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
                    data.genericErrorDesc = "Could not save: \(error.localizedDescription)"
                    data.genericErrorAlert.toggle()
                }
            }
            Picker("Skill", selection: $data.selectedSkill){
                ForEach(Array(data.c.skills.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            .frame(width: 120)
            Picker("Period", selection: $data.selectedPeriod){
                ForEach(0...3, id: \.self){
                    Text("Skill "+String($0+1)).tag($0)
                }
            }
            TextField("Search...", text: $search)
                .frame(width: 100)
                .textFieldStyle(.roundedBorder)
        }
        //Somehow, you can't have more than one file exporter in a single view.
        //WHY?
        .fileExporter(isPresented: $showSkillCsvExporter, document: CSVFile(initialText: csvExport),
                      contentType: .csv, defaultFilename: data.selectedSkill+" - Skill "+String(data.selectedPeriod+1)) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                data.genericErrorDesc = "Could not save: \(error.localizedDescription)"
                data.genericErrorAlert.toggle()
            }
        }
    }
}

struct SkillView_Previews: PreviewProvider {
    static var previews: some View {
        SkillView()
            .environmentObject(CampData())
    }
}
