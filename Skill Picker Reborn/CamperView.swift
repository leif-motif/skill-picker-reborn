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
    var body: some View {
        VStack(){
            Text(filename)
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
                    
                } label: {
                  Label("New Camper...", systemImage: "plus")
                }
              } else if items.count == 1 {
                Button {
                    
                } label: {
                  Label("Info/Edit...", systemImage: "pencil.line")
                }
                Button(role: .destructive) {
                    
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              } else {
                Button {
                    
                } label: {
                  Label("Info/Edit Selection...", systemImage: "pencil.line")
                }
                Button(role: .destructive) {
                    
                } label: {
                  Label("Delete Selection", systemImage: "trash")
                }
              }
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName:"person.badge.plus")
            }
            .help("Add Camper")
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.allowedContentTypes = [.csv]
                if panel.runModal() == .OK {
                    self.filename = panel.url?.lastPathComponent ?? "<none>"
                }
            } label: {
                Image(systemName: "square.and.arrow.down")
            }
            .help("Import file")
            Button {
                
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .help("Export Schedule")
            TextField(" This search bar doesn't work. ", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
        }
    }
}


struct CamperView_Previews: PreviewProvider {
    static var previews: some View {
        CamperView()
    }
}
