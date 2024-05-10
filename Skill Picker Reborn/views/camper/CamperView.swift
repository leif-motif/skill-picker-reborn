/*
 * CamperView.swift
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
import UniformTypeIdentifiers

struct CamperView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var camperEditPass: HumanSelection<Camper>?
    @State private var camperDestPass: HumanSelection<Camper>?
    @State private var csvInput: [Substring] = [""]
    @State private var showFileChooser = false
    @State private var showCsvExporter = false
    @State private var addCamperSheet = false
    @State private var importSkillSheet = false
    @State private var preferredSkillsAlert = false
    @State private var deleteCamperConfirm = false
    @State private var search = ""
    var body: some View {
        VStack(){
            Table(data.campers, selection: $selectedCamper, sortOrder: $data.camperSortOrder){
                TableColumn("First Name",value: \.fName)
                    .width(min: 80, ideal: 80)
                TableColumn("Last Name",value: \.lName)
                    .width(min: 80, ideal: 80)
                TableColumn("Cabin",value: \.cabin)
                    .width(min: 80, ideal: 80)
                TableColumn("Skill%"){ camper in
                    Text(prefSkillPercentage(targetCamper: camper))
                }
                    .width(min: 40, ideal: 40)
                //see comment in LeaderView.swift
                //ForEach(0...3, id: \.self){
                //    TableColumn("Skill "+String($0+1),value: \.skills[$0])
                //        .width(min: 80, ideal: 80)
                //}
                TableColumn("Skill 1",value: \.skills[0])
                    .width(min: 80, ideal: 80)
                TableColumn("Skill 2",value: \.skills[1])
                    .width(min: 80, ideal: 80)
                TableColumn("Skill 3",value: \.skills[2])
                    .width(min: 80, ideal: 80)
                TableColumn("Skill 4",value: \.skills[3])
                    .width(min: 80, ideal: 80)
            }
            .onChange(of: data.camperSortOrder){
                data.campers.sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
                let camperSelectionUnion = selectedCamper.union(items)
                if(camperSelectionUnion.isEmpty){
                    Button {
                        addCamperSheet.toggle()
                    } label: {
                        Label("New Camper...", systemImage: "plus")
                    }
                } else if(camperSelectionUnion.count == 1){
                    Button {
                        camperEditPass = HumanSelection(selection: camperSelectionUnion)
                    } label: {
                        Label("Info/Edit...", systemImage: "person.text.rectangle")
                    }
                }
                if(camperSelectionUnion.count > 0){
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
            //empty selection
            .contextMenu {
                Button {
                    addCamperSheet.toggle()
                } label: {
                    Label("New Camper...", systemImage: "plus")
                }
            }
        }
        .toolbar {
            Button {
                addCamperSheet.toggle()
            } label: {
                Image(systemName:"person.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Camper")
            Button {
                camperDestPass = HumanSelection(selection: selectedCamper)
                deleteCamperConfirm.toggle()
            } label: {
                Image(systemName:"person.badge.minus")
                    .foregroundColor(selectedCamper.count == 0 ? Color(.systemGray) : Color(.systemRed))
            }
            .help("Delete Camper")
            .disabled(selectedCamper.count == 0)
            Button {
                camperEditPass = HumanSelection(selection: selectedCamper)
            } label: {
                Image(systemName:"person.text.rectangle")
                    .foregroundColor(selectedCamper.count != 1 ? Color(.systemGray) : Color(.systemOrange))
            }
            .help("Get Camper Info")
            .disabled(selectedCamper.count != 1)
            Button {
                do {
                    try processPreferredSkills(data: data)
                    data.objectWillChange.send()
                    //honestly this really should catch specific errors but whatver, i'll attribute that to yet another compiler error.
                } catch {
                    preferredSkillsAlert.toggle()
                    print("\(error)")
                }
            } label: {
                Image(systemName: "figure.run.square.stack")
                    .foregroundColor(Color(.systemIndigo))
            }
            .help("Assign Preferred Skills")
            .alert(isPresented: $preferredSkillsAlert) {
                Alert(title: Text("Error!"),
                      message: Text("There is not enough skill space to accommodate all potential campers."),
                      dismissButton: .default(Text("Dismiss")))
            }
            Button {
                data.objectWillChange.send()
                clearAllCamperSkills(data: data)
            } label: {
                Image(systemName: "person.2.gobackward")
                    .foregroundColor(Color(.systemRed))
            }
            .help("Clear All Skills")
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
                showCsvExporter.toggle()
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Schedule for all Campers")
            .fileExporter(isPresented: $showCsvExporter, document: CSVFile(initialText: camperListToCSV(data: data)),
                          contentType: .csv, defaultFilename: "Campers") { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            #warning("TODO: implement search bar")
            TextField("Search...", text: $search)
                .frame(width: 100)
                .disabled(true)
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
        .sheet(isPresented: $addCamperSheet) {
        } content: {
            AddCamperView()
        }
        .sheet(item: $camperEditPass, onDismiss: {
            data.objectWillChange.send()
        }, content: { x in
            CamperInfoView(camperID: x.selection.first!)
        })
    }
}

struct CamperView_Previews: PreviewProvider {
    static var previews: some View {
        CamperView()
            .environmentObject(CampData())
    }
}
