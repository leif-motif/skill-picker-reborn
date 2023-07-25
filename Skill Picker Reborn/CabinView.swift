//
//  CabinView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-07-25.
//

import SwiftUI

struct CabinView: View {
    @State private var selectedCabin: String = "Unassigned"
    @State private var sortOrder = [KeyPathComparator(\Camper.lName)]
    var body: some View {
        VStack {
            Text(try! AttributedString(markdown: "**Senior:** "+fooCabins[selectedCabin]!.senior.fName+" "+fooCabins[selectedCabin]!.senior.lName))
                .font(.title2)
                .padding(.top)
                .padding(.bottom,5)
            Text(try! AttributedString(markdown: "**Junior:** "+fooCabins[selectedCabin]!.junior.fName+" "+fooCabins[selectedCabin]!.junior.lName))
                .font(.title2)
            Table(fooCabins[selectedCabin]!.campers, sortOrder: $sortOrder){
                TableColumn("First Name",value: \.fName)
                TableColumn("Last Name",value: \.lName)
                TableColumn("Skill 1",value: \.skillOne)
                TableColumn("Skill 2",value: \.skillTwo)
                TableColumn("Skill 3",value: \.skillThree)
                TableColumn("Skill 4",value: \.skillFour)
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "rectangle.stack.badge.plus")
            }
            .help("Add Skill")
            Button {
                
            } label: {
                Image(systemName: "rectangle.badge.plus")
            }
            .help("Add Fanatic")
            Picker("Cabin", selection: $selectedCabin) {
                ForEach(validCabins, id: \.self){
                    Text($0).tag($0)
                }
            }
            TextField("Search", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
        }
    }
}

struct CabinView_Previews: PreviewProvider {
    static var previews: some View {
        CabinView()
    }
}
