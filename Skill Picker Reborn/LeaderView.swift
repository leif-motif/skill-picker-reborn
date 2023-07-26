//
//  LeaderView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct LeaderView: View {
    @State private var sortOrder = [KeyPathComparator(\Leader.lName)]
    @State private var selectedLeader = Set<Leader.ID>()
    var body: some View {
        VStack(){
            Table(fooLeaders, selection: $selectedLeader, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
                TableColumn("Skill 1",value: \.skillOne)
                TableColumn("Skill 2",value: \.skillTwo)
                TableColumn("Skill 3",value: \.skillThree)
                TableColumn("Skill 4",value: \.skillFour)
            }
            .onChange(of: sortOrder){
                fooLeaders.sort(using: $0)
            }
            .contextMenu(forSelectionType: Leader.ID.self) { items in
              if items.isEmpty {
                Button {
                    
                } label: {
                  Label("New Leader...", systemImage: "plus")
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
            .help("Add Leader")
            Button {
                
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

struct LeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderView()
    }
}
