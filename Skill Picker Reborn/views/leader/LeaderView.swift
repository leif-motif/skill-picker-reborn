/*
 * LeaderView.swift
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

struct LeaderView: View {
    @EnvironmentObject private var data: CampData
    @State private var selectedLeader = Set<Leader.ID>()
    #warning("TODO: fix selection passing")
    @State private var leaderSelectionPass = Set<Leader.ID>()
    @State private var showCsvExporter = false
    @State private var addLeaderSheet = false
    @State private var leaderInfoSheet = false
    @State private var search = ""
    var body: some View {
        VStack(){
            Table(data.leaders, selection: $selectedLeader, sortOrder: $data.leaderSortOrder){
                TableColumn("First Name",value: \.fName)
                    .width(min: 80, ideal: 80)
                TableColumn("Last Name",value: \.lName)
                    .width(min: 80, ideal: 80)
                TableColumn("Cabin",value: \.cabin)
                    .width(min: 80, ideal: 80)
                //"The compiler is unable to type-check this expression in reasonable time" my ass
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
            .onChange(of: data.leaderSortOrder){
                data.leaders.sort(using: $0)
            }
            .contextMenu(forSelectionType: Leader.ID.self) { items in
                if(selectedLeader.union(items).isEmpty){
                    Button {
                        addLeaderSheet.toggle()
                    } label: {
                        Label("New Leader...", systemImage: "plus")
                    }
                } else if(selectedLeader.union(items).count == 1){
                    Button {
                        leaderSelectionPass = selectedLeader.union(items)
                        leaderInfoSheet.toggle()
                    } label: {
                        Label("Info/Edit...", systemImage: "pencil.line")
                    }
                    Button(role: .destructive) {
                        deleteLeader(leaderID: selectedLeader.union(items).first!, data: data)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        for leaderID in selectedLeader.union(items){
                            deleteLeader(leaderID: leaderID, data: data)
                        }
                    } label: {
                        Label("Delete Selection", systemImage: "trash")
                    }
                }
            }
            //empty selection
            .contextMenu {
                Button {
                    addLeaderSheet.toggle()
                } label: {
                    Label("New Leader...", systemImage: "plus")
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
            .sheet(isPresented: $addLeaderSheet) {
            } content: {
                AddLeaderView()
            }
            Button {
                for leaderID in selectedLeader {
                    deleteLeader(leaderID: leaderID, data: data)
                }
            } label: {
                Image(systemName:"person.badge.minus")
                    .foregroundColor(selectedLeader.count == 0 ? Color(.systemGray) : Color(.systemRed))
            }
            .help("Delete Leader")
            .disabled(selectedLeader.count == 0)
            Button {
                leaderInfoSheet.toggle()
            } label: {
                Image(systemName:"person.text.rectangle")
                    .foregroundColor(selectedLeader.count != 1 ? Color(.systemGray) : Color(.systemOrange))
            }
            .help("Get Camper Info")
            .disabled(selectedLeader.count != 1)
            Button {
                showCsvExporter.toggle()
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
                .foregroundColor(Color(.systemBlue))
            }
            .help("Export Schedule for all Leaders")
            .fileExporter(isPresented: $showCsvExporter, document: CSVFile(initialText: leaderListToCSV(data: data)),
                          contentType: .csv, defaultFilename: "Leaders") { result in
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
        .sheet(isPresented: $leaderInfoSheet, onDismiss: {
            data.objectWillChange.send()
        }, content: {
            LeaderInfoView(leaderID: leaderSelectionPass.first!)
        })
    }
}

struct LeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderView()
            .environmentObject(CampData())
    }
}
