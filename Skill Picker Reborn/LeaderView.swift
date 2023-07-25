//
//  LeaderView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct LeaderView: View {
    @State private var sortOrder = [KeyPathComparator(\Leader.lName)]
    var body: some View {
        VStack(){
            Table(fooLeaders, sortOrder: $sortOrder){
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
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "doc")
            }
            .help("Select File")
            Button {
                
            } label: {
                Image(systemName:"person.badge.plus")
            }
            .help("Add Leader")
            Button {
                
            } label: {
                Image(systemName: "arrow.up.doc.on.clipboard")
            }
            .help("Export Schedules")
            TextField("Search", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
        }
    }
}

struct LeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderView()
    }
}
