//
//  CamperInfoView.swift
//  Skill Picker Reborn
//
//  Created by Leif Benson on 2023-08-01.
//

import SwiftUI

struct CamperInfoView: View {
    private var inputCamper: Camper
    private let numbers = ["One","Two","Three","Four","Five","Six"]
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Text(try! AttributedString(markdown: "**Name:** "+inputCamper.fName+" "+inputCamper.lName))
                .padding([.top,.horizontal])
            Text(try! AttributedString(markdown: "**Cabin:** "+inputCamper.cabin))
                .padding(.horizontal)
            Text(try! AttributedString(markdown: "**Fanatic:** "+inputCamper.fanatic))
                .padding(.horizontal)
            Text("Skills:")
                .bold()
                .padding([.top,.horizontal])
            ForEach(0...3, id: \.self){
                Text(try! AttributedString(markdown: "**Skill "+numbers[$0]+":** "+inputCamper.skills[$0]))
                    .padding(.horizontal)
            }
            Text("Preferred Skills:")
                .bold()
                .padding([.top,.horizontal])
            //if the camper isn't in fanatic, go for six skills, otherwise do five
            ForEach(0...(inputCamper.fanatic == "None" ? 5 : 4), id: \.self){
                Text(try! AttributedString(markdown: "**"+numbers[$0]+":** "+inputCamper.preferredSkills[$0]))
                    .padding(.horizontal)
            }
            Button("Dismiss") {
                dismiss()
            }
            .padding()
        }
    }
    init(camperSelection: Set<Camper.ID>) throws {
        if(camperSelection.count != 1){
            throw SPRError.EmptySelection
        }
        self.inputCamper = campers.first(where: {$0.id == camperSelection.first})!
    }
}

/*
struct CamperInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CamperInfoView()
    }
}*/
