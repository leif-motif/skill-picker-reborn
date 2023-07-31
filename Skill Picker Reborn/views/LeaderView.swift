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
            Table(fooLeaders, selection: $selectedLeader, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Cabin",value: \.cabin)
                //There is FOR SURE a better way to do this with something like a for statement.
                //BUT NO, "Closure containing control flow statement cannot be used with result builder" like shut up.
                TableColumn("Skill 1",value: \.skills[0])
                TableColumn("Skill 2",value: \.skills[1])
                TableColumn("Skill 3",value: \.skills[2])
                TableColumn("Skill 4",value: \.skills[3])
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
                    deleteLeader(leaderSelection: selectedLeader)
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              } else {
                Button(role: .destructive) {
                    deleteLeader(leaderSelection: selectedLeader)
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
                deleteLeader(leaderSelection: selectedLeader)
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
            //This search bar STILL doesn't work.
            TextField("Search...", text: $search)
                .frame(width: 100)
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
