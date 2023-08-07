//
//  CabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct CabinView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedCabin: String = "Unassigned"
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    @State private var csvInput: [Substring] = [""]
    @State private var addCabinSheet = false
    @State private var modifyCabinLeadersSheet = false
    @State private var importSkillSheet = false
    @State private var unassignedCabinAlert = false
    @State private var search = ""
    var body: some View {
        VStack {
            Text(try! AttributedString(markdown: "**Senior:** "+data.cabins[selectedCabin]!.senior.fName+" "+data.cabins[selectedCabin]!.senior.lName))
                .font(.title2)
                .padding(.top,10)
                .padding(.bottom,2)
            Text(try! AttributedString(markdown: "**Junior:** "+data.cabins[selectedCabin]!.junior.fName+" "+data.cabins[selectedCabin]!.junior.lName))
                .font(.title2)
            Table(data.cabins[selectedCabin]!.campers, selection: $selectedCamper, sortOrder: $sortOrder){
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
            .onChange(of: sortOrder){
                data.cabins[selectedCabin]!.campers.sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
                if items.isEmpty {
                    Button {
                        //assign camper with this cabin
                    } label: {
                        Label("Assign Camper to Cabin...", systemImage: "plus")
                    }
                } else if items.count == 1 {
                    /*Button {
                     
                     } label: {
                     Label("Info/Edit...", systemImage: "pencil.line")
                     }*/
                    Button(role: .destructive) {
                        removeCamperFromCabin(camperSelection: selectedCamper, data: data)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper, data: data)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        removeCamperFromCabin(camperSelection: selectedCamper, data: data)
                    } label: {
                        Label("Remove Selection", systemImage: "trash")
                    }
                    Button(role: .destructive) {
                        deleteCamper(camperSelection: selectedCamper, data: data)
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
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
            Button {
                if(selectedCabin == "Unassigned"){
                    unassignedCabinAlert.toggle()
                } else {
                    try! deleteCabin(targetCabin: selectedCabin, data: data)
                }
            } label: {
                Image(systemName: "minus.square")
                    .foregroundColor(Color(.systemRed))
            }
            .help("Delete Cabin")
            Button {
                if(selectedCabin == "Unassigned"){
                    unassignedCabinAlert.toggle()
                } else {
                    modifyCabinLeadersSheet.toggle()
                }
            } label: {
                Image(systemName: "person.2.badge.gearshape")
                    .foregroundColor(Color(.systemOrange))
            }
            .help("Edit Cabin Leaders")
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
                //export cabin schedule
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                    .foregroundColor(Color(.systemBlue))
            }
            .help("Export Cabin Schedule")
            Picker("Cabin", selection: $selectedCabin) {
                ForEach(Array(data.cabins.keys).sorted(), id: \.self){
                    Text($0).tag($0)
                }
            }
            //This search bar STILL doesn't work.
            TextField("Search... ", text: $search)
                .frame(width: 100)
        }
        .sheet(isPresented: $addCabinSheet) {
        } content: {
            AddCabinView()
        }
        .sheet(isPresented: $modifyCabinLeadersSheet) {
        } content: {
            ModifyCabinLeadersView(targetCabin: selectedCabin)
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
        .alert(isPresented: $unassignedCabinAlert) {
            Alert(title: Text("Error!"),
                  message: Text("Cannot modify/delete the \"Unassigned\" cabin."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct CabinView_Previews: PreviewProvider {
    static var previews: some View {
        CabinView()
    }
}
