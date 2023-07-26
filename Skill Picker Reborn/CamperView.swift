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
    @State var campers: [Camper] = []
    var body: some View {
        VStack(){
            Table(fooCampers, selection: $selectedCamper, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
                TableColumn("Skill 1",value: \.skillOne)
                TableColumn("Skill 2",value: \.skillTwo)
                TableColumn("Skill 3",value: \.skillThree)
                TableColumn("Skill 4",value: \.skillFour)
            }
            .onChange(of: sortOrder){
                fooCampers.sort(using: $0)
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
                    
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              } else {
                Button(role: .destructive) {
                    
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
                //remove camper from cabin
                fooCabins[fooCampers.first(where: {$0.id == selectedCamper.first})!.cabin]!.campers.removeAll(where: {$0.id == selectedCamper.first})
                //remove camper from skills
                if(fooCampers.first(where: {$0.id == selectedCamper.first})!.skillOne != "None"){
                    fooSkills[fooCampers.first(where: {$0.id == selectedCamper.first})!.skillOne]!.periods[0].removeAll(where: {$0.id == selectedCamper.first})
                }
                if(fooCampers.first(where: {$0.id == selectedCamper.first})!.skillTwo != "None"){
                    fooSkills[fooCampers.first(where: {$0.id == selectedCamper.first})!.skillTwo]!.periods[1].removeAll(where: {$0.id == selectedCamper.first})
                }
                if(fooCampers.first(where: {$0.id == selectedCamper.first})!.skillThree != "None"){
                    fooSkills[fooCampers.first(where: {$0.id == selectedCamper.first})!.skillThree]!.periods[2].removeAll(where: {$0.id == selectedCamper.first})
                }
                if(fooCampers.first(where: {$0.id == selectedCamper.first})!.skillFour != "None"){
                    fooSkills[fooCampers.first(where: {$0.id == selectedCamper.first})!.skillFour]!.periods[3].removeAll(where: {$0.id == selectedCamper.first})
                }
                //delete camper for good
                fooCampers.removeAll(where: {$0.id == selectedCamper.first})
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
                
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Schedule for all Campers")
            TextField(" This search bar doesn't work. ", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
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
