/*
 * CabinView.swift
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

struct CabinView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var camperEditPass: HumanSelection<Camper>?
    @State private var camperDestPass: HumanSelection<Camper>?
    @State private var csvInput: [Substring] = [""]
    @State private var showCsvExporter = false
    @State private var addCabinSheet = false
    @State private var modifyCabinSheet = false
    @State private var assignCabinCamperSheet = false
    @State private var importSkillSheet = false
    @State private var exportCabinAlert = false
    @State private var removeCamperConfirm = false
    @State private var deleteCamperConfirm = false
    @State private var deleteCabinConfirm = false
    @State private var csvErrorAlert = false
    @State private var search = ""
    var body: some View {
        VStack {
            #warning("TODO: allow for editing/removal/deletion of leaders with context menu")
            Text(try! AttributedString(markdown: "**Senior:** "+data.cabins[data.selectedCabin]!.senior.fName+" "+data.cabins[data.selectedCabin]!.senior.lName))
                .font(.title2)
                .padding(.top,10)
                .padding(.bottom,2)
            Text(try! AttributedString(markdown: "**Junior:** "+data.cabins[data.selectedCabin]!.junior.fName+" "+data.cabins[data.selectedCabin]!.junior.lName))
                .font(.title2)
            Table(data.cabins[data.selectedCabin]!.campers, selection: $selectedCamper, sortOrder: $data.cabinCamperSortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                //see comment in LeaderView.swift
                //ForEach(0...3, id: \.self){
                //    TableColumn("Skill "+String($0+1),value: \.skills[$0])
                //}
                TableColumn("Skill 1",value: \.skills[0])
                TableColumn("Skill 2",value: \.skills[1])
                TableColumn("Skill 3",value: \.skills[2])
                TableColumn("Skill 4",value: \.skills[3])
            }
            .onChange(of: data.cabinCamperSortOrder){
                data.objectWillChange.send()
                data.cabins[data.selectedCabin]!.campers.sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
                let selectedCamperUnion = selectedCamper.union(items)
                if(selectedCamperUnion.isEmpty){
                    Button {
                        assignCabinCamperSheet.toggle()
                    } label: {
                        Label("Assign Camper to Cabin...", systemImage: "plus")
                    }
                    .disabled(data.campers.count == 0)
                } else if(selectedCamperUnion.count == 1){
                    Button {
                        camperEditPass = HumanSelection(selection: selectedCamperUnion)
                    } label: {
                        Label("Info/Edit...", systemImage: "pencil.line")
                    }
                }
                if(selectedCamperUnion.count > 0){
                    Button(role: .destructive) {
                        camperDestPass = HumanSelection(selection: selectedCamperUnion)
                        removeCamperConfirm.toggle()
                    } label: {
                        if(selectedCamperUnion.count == 1){
                            Label("Remove", systemImage: "trash")
                        } else {
                            Label("Remove Selection", systemImage: "trash")
                        }
                    }
                    Button(role: .destructive) {
                        camperDestPass = HumanSelection(selection: selectedCamperUnion)
                        deleteCamperConfirm.toggle()
                    } label: {
                        if(selectedCamperUnion.count == 1){
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
                    assignCabinCamperSheet.toggle()
                } label: {
                    Label("Assign Camper to Cabin...", systemImage: "plus")
                }
                .disabled(data.campers.count == 0)
            }
        }
        .toolbar {
            Button {
                addCabinSheet.toggle()
            } label: {
                Image(systemName: "plus.square")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Cabin")
            .sheet(isPresented: $addCabinSheet, onDismiss: {
                data.objectWillChange.send()
            }, content: {
                ModifyCabinView()
            })
            Button {
                deleteCabinConfirm.toggle()
            } label: {
                Image(systemName: "minus.square")
                    .foregroundColor(data.selectedCabin == "Unassigned" ? Color(.systemGray) : Color(.systemRed))
            }
            .help("Delete Cabin")
            .disabled(data.selectedCabin == "Unassigned")
            .alert(isPresented: $deleteCabinConfirm){
                Alert(
                    title: Text("Confirm"),
                    message: Text("Are you sure you want to delete the current cabin?"),
                    primaryButton: .default(Text("Delete")){
                        data.objectWillChange.send()
                        try! deleteCabin(targetCabin: data.selectedCabin, data: data)
                        data.selectedCabin = "Unassigned"
                    },
                    secondaryButton: .cancel()
                )
            }
            Button {
                modifyCabinSheet.toggle()
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(data.selectedCabin == "Unassigned" ? Color(.systemGray) : Color(.systemOrange))
            }
            .help("Edit Cabin")
            .disabled(data.selectedCabin == "Unassigned")
            .sheet(isPresented: $modifyCabinSheet, onDismiss: {
                data.objectWillChange.send()
            }, content: {
                ModifyCabinView(targetCabin: data.selectedCabin)
            })
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.allowedContentTypes = [.csv]
                if panel.runModal() == .OK {
                    do {
                        csvInput = try String(contentsOf: panel.url!).lines
                        data.importSkillList = try skillListFromCSV(csv: csvInput)
                        importSkillSheet.toggle()
                    } catch SPRError.InvalidFileFormat {
                        csvErrorAlert.toggle()
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
                data.objectWillChange.send()
            }, content: {
                try! ImportSkillView(data: data)
            })
            Button {
                if(data.cabins[data.selectedCabin]!.campers.count > 0){
                    showCsvExporter.toggle()
                } else {
                    exportCabinAlert.toggle()
                }
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                    .foregroundColor(Color(.systemBlue))
            }
            .help("Export Cabin Schedule")
            .fileExporter(isPresented: $showCsvExporter, document: CSVFile(initialText: cabinListToCSV(cabinName: data.selectedCabin, data: data)),
                          contentType: .csv, defaultFilename: data.selectedCabin) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .alert(isPresented: $exportCabinAlert){
                Alert(title: Text("Error!"),
                      message: Text("Cannot export a schedule for a cabin that has no campers."),
                      dismissButton: .default(Text("Dismiss")))
            }
            Picker("Cabin", selection: $data.selectedCabin) {
                ForEach(Array(data.cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            #warning("TODO: implement search bar")
            TextField("Search... ", text: $search)
                .frame(width: 100)
                .disabled(true)
        }
        .sheet(isPresented: $assignCabinCamperSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            AssignCabinCamperView(targetCabin: data.selectedCabin)
        })
        .sheet(item: $camperEditPass, onDismiss: {
            data.objectWillChange.send()
        }, content: { x in
            CamperInfoView(camperID: x.selection.first!)
        })
        .alert("Error!", isPresented: $csvErrorAlert){
            Button(){
            } label: {
                Text("Dismiss")
            }
        } message: {
            Text("The provided CSV is probably invalid. If there are any skills that no camper has set as a preferred skill, remove that skill.")
        }
        .confirmationDialog("Confirm Removal", isPresented: $removeCamperConfirm, presenting: camperDestPass){ p in
            Button(role: .cancel){
                
            } label: {
                Text("Cancel")
            }
            Button(role: .destructive){
                for camperID in p.selection {
                    removeCamperFromCabin(camperID: camperID, data: data)
                }
                camperDestPass = nil
                selectedCamper = []
            } label: {
                Text("Remove")
            }
        } message: { p in
            if(p.selection.count == 1){
                Text("Are you sure you want to remove the selected camper from the cabin?")
            } else {
                Text("Are you sure you want to remove "+String(p.selection.count)+" campers from the cabin?")
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
}

struct CabinView_Previews: PreviewProvider {
    static var previews: some View {
        CabinView()
            .environmentObject(CampData())
    }
}
