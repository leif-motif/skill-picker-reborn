//
//  CabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct CabinView: View {
    @State private var selectedCabin: String = "Unassigned"
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    @State private var addCabinSheet = false
    @State private var modifyCabinLeadersSheet = false
    @State private var unassignedCabinAlert = false
    @State private var search = ""
    var body: some View {
        VStack {
            Text(try! AttributedString(markdown: "**Senior:** "+cabins[selectedCabin]!.senior.fName+" "+cabins[selectedCabin]!.senior.lName))
                .font(.title2)
                .padding(.top,10)
                .padding(.bottom,2)
            Text(try! AttributedString(markdown: "**Junior:** "+cabins[selectedCabin]!.junior.fName+" "+cabins[selectedCabin]!.junior.lName))
                .font(.title2)
            Table(cabins[selectedCabin]!.campers, selection: $selectedCamper, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                //see comment in LeaderView.swift
                TableColumn("Skill 1",value: \.skills[0])
                TableColumn("Skill 2",value: \.skills[1])
                TableColumn("Skill 3",value: \.skills[2])
                TableColumn("Skill 4",value: \.skills[3])
            }
            .onChange(of: sortOrder){
                cabins[selectedCabin]!.campers.sort(using: $0)
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
                        removeCamperFromCabin(camperSelection: selectedCamper)
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
                        removeCamperFromCabin(camperSelection: selectedCamper)
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
                    try! deleteCabin(targetCabin: selectedCabin)
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
                //export cabin schedule
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                    .foregroundColor(Color(.systemBlue))
            }
            .help("Export Cabin Schedule")
            Picker("Cabin", selection: $selectedCabin) {
                ForEach(Array(cabins.keys).sorted(), id: \.self){
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
