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
    @State private var addLeaderSheet = false
    @State private var search = ""
    var body: some View {
        VStack(){
            Table(fooLeaders[2...], selection: $selectedLeader, sortOrder: $sortOrder){
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
                    addLeaderSheet.toggle()
                } label: {
                  Label("New Leader...", systemImage: "plus")
                }
              } else if items.count == 1 {
                /*Button {
                    
                } label: {
                  Label("Info/Edit...", systemImage: "pencil.line")
                }*/
                Button(role: .destructive) {
                    //delete leader
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              } else {
                Button(role: .destructive) {
                    //delete leaders
                } label: {
                  Label("Delete Selection", systemImage: "trash")
                }
              }
            }
        }
        .toolbar {
            Button {
                addLeaderSheet.toggle()
            } label: {
                Image(systemName:"person.badge.plus")
                    .foregroundColor(Color(.systemGreen))
            }
            .help("Add Leader")
            Button {
                //delete leader
            } label: {
                Image(systemName:"person.badge.minus")
                    .foregroundColor(Color(.systemRed))
            }
            .help("Delete Leader")
            /*Button {
                
            } label: {
                Image(systemName:"pencil.line")
                    .foregroundColor(Color(.systemOrange))
            }
            .help("Edit Leader")*/
            Button {
                //export schedule for all leaders
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Schedule for all Leaders")
            TextField(" This search bar doesn't work. ", text: $search)
        }
        .sheet(isPresented: $addLeaderSheet) {
        } content: {
            AddLeaderView()
        }
    }
}

struct LeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderView()
    }
}
