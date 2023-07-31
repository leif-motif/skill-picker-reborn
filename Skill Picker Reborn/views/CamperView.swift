//
//  CamperView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-24.
//

import SwiftUI
import UniformTypeIdentifiers

struct CamperView: View {
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    @State private var selectedCamper = Set<Camper.ID>()
    @State private var filename = "Filename"
    @State private var showFileChooser = false
    @State private var addCamperSheet = false
    @State private var search = ""
    var body: some View {
        VStack(){
            Table(campers, selection: $selectedCamper, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
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
                campers.sort(using: $0)
            }
            .contextMenu(forSelectionType: Camper.ID.self) { items in
              if items.isEmpty {
                Button {
                    addCamperSheet.toggle()
                } label: {
                  Label("New Camper...", systemImage: "plus")
                }
              } else if items.count == 1 {
                /*Button {
                    
                } label: {
                  Label("Info/Edit...", systemImage: "pencil.line")
                }*/
                Button(role: .destructive) {
                    deleteCamper(camperSelection: selectedCamper)
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              } else {
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
                addCamperSheet.toggle()
            } label: {
                Image(systemName:"person.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Camper")
            Button {
                deleteCamper(camperSelection: selectedCamper)
            } label: {
                Image(systemName:"person.badge.minus")
                    .foregroundColor(Color(.systemRed))
            }
            .help("Delete Camper")
            /*Button {
                
            } label: {
                Image(systemName:"pencil.line")
                    .foregroundColor(Color(.systemOrange))
            }
            .help("Edit Camper")*/
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.allowedContentTypes = [.csv]
                if panel.runModal() == .OK {
                    self.filename = panel.url?.lastPathComponent ?? "<none>"
                }
            } label: {
                Image(systemName: "arrow.down.doc")
                    .foregroundColor(Color(.systemBlue))
            }
            .help("Import file")
            Button {
                //export schedule for all campers
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Schedule for all Campers")
            TextField("Search...", text: $search)
                .frame(width: 100)
        }
        .sheet(isPresented: $addCamperSheet) {
        } content: {
            AddCamperView()
        }
    }
}

struct CamperView_Previews: PreviewProvider {
    static var previews: some View {
        CamperView()
    }
}
