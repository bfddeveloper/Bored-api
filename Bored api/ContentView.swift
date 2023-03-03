//
//  ContentView.swift
//  Bored api
//
//  Created by Brody Dickson on 2/27/23.
//

import SwiftUI


import Foundation
import SwiftUI
struct ContentView: View {
    @State private var activity: String = ""
    @State private var activityArray = [String]()
    @State private var showingAlert = false
    @State private var isSelected = false
    var body: some View {
        ZStack{
            Color.green
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("An activity you should do today:")
                    .padding()
                HStack {
                    Button {
                        activityArray.append(activity)
                    } label : {
                       "+"
                    }
                    .buttonStyle(GrowingButton())
                    Text(activity)
                }
                Button {
                    Task {
                       await GetActivity()
                    }
                } label: {
                    Text("random")
                }
                .buttonStyle(GrowingButton())
                .alert(isPresented: $showingAlert){
                    Alert(title: Text ("Loading Error"),
                          message:Text("There was a problem loading the API Categories"),
                          dismissButton: .default(Text("OK"))
                    )
                }
                            
                Spacer()
            }
        }
    }
    func GetActivity() async {
        if let (data, _) = try? await URLSession.shared.data(from: URL(string:"https://www.boredapi.com/api/activity")!) {
            let decodedResponse = try? JSONDecoder().decode(Ping.self, from: data)
            activity = decodedResponse?.activity ?? ""
            return
        }
        showingAlert = true
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Ping: Codable {
    let activity: String
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
