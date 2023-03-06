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
    @State private var activity: String = "I wonder what you could do today?"
    @State private var activityArray = [""]
    @State private var showingAlert = false
    @State private var isSelected = false
    @State private var added = false
    var body: some View {
        ZStack{
            Color.green
                .ignoresSafeArea()
            VStack{
                Text("An activity you should do today:")
                    .padding()
                    .fontWeight(.heavy)
                    .bold()
                Spacer()
                HStack {
                    Button {
                        if added == false {
                            activityArray.append(activity)
                            added = true
                        }
                    } label : {
                       Text("+")
                    }
                    .buttonStyle(GrowingButton())
                    .shadow(color: isSelected ? .blue : .gray, radius: 5, x: 0.5, y: 0.5)
                    Text(activity)
                }
                Button {
                    added = false
                    Task {
                        
                       await GetActivity()
                    }
                } label: {
                    Text("random")
                }
                .buttonStyle(GrowingButton())
                .alert(isPresented: $showingAlert){
                    Alert(title: Text ("Loading Error"),
                          message:Text("There was a problem loading the API"),
                          dismissButton: .default(Text("OK"))
                    )
                }
                ZStack{
                    Color.init(red: 0.0, green: 0.9, blue: 0.5)
                    VStack {
                        Text("Your list:")
                        ForEach(0 ..< activityArray.count, id: \.self) { value in
                            HStack{
                                Button {
                                    activityArray.remove(at: value)
                                } label : {
                                    Text("-")
                                }
                                .background(.blue)
                                .foregroundColor(.white)
                                
                                Text("\(activityArray[value])")
                            }
                            
                        }
                        Spacer()
                    }
                }
                
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
