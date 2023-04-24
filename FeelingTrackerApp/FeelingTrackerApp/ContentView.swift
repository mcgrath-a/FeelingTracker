import SwiftUI

struct BlueButton: ButtonStyle {
    @EnvironmentObject private var appColorSettings: AppColorSettings

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(appColorSettings.primaryButtonColor)

            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(maxWidth: .infinity)
            .border(.white)
            .controlSize(.small)
            .padding()
          

            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 20, height: 15)
                Text("Back")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.black)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .cornerRadius(5)
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    class Coordinator: NSObject {
        var parent: SearchBar

        init(_ parent: SearchBar) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

struct CategorySelectionView: View {
    @AppStorage("userName") private var userName: String = ""
    @Binding var selectedCategory: Category?

    var body: some View {
        ScrollView {
            VStack {
                //var  wave = "👋🏾"
                Text("Hi, \(userName) 👋🏾! ")
                
                Text("Select a Category")
                    .font(.largeTitle)
                    .padding()
                
                ForEach(Category.allCases, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category.rawValue)
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                    
                }.buttonStyle(.borderedProminent)
                .tint(.cyan)
            }
            .frame(maxWidth: .infinity)}
    }
}

struct CommentPromptView: View {
    @ObservedObject var feelingData: FeelingData
    @Binding var showCommentPrompt: Bool
    @Binding var userComment: String
    @Binding var showResult: Bool
    @Binding var selectedFeeling: Feeling?

    var body: some View {
        VStack {
            Text("Would you like to add a comment?")
                .font(.largeTitle)
                .padding()

            TextField("Enter a comment", text: $userComment)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5)

            Button(action: {
                feelingData.recordFeeling(feeling: selectedFeeling!, date: Date(), comment: userComment) 
                showCommentPrompt = false
                showResult = true
                
              
               
                
            }) {
                Text("Submit")
                    .font(.title)
                    .padding()
                    .foregroundColor(.green)
                    .clipShape(Capsule())
                    .controlSize(.small)
            }
           
            .padding(.bottom, 10)

            Button(action: {
                feelingData.recordFeeling(feeling: selectedFeeling!, date: Date(), comment: "") // Add this line
                userComment = ""
                showCommentPrompt = false
                showResult = true
                
                
            }) {
                Text("No")
                    .font(.title)
                    .padding()
                    .foregroundColor(.red)
                    .clipShape(Capsule())
                    .controlSize(.small)
            }
           
        }
        .toolbar {
            // 2
            ToolbarItem(placement: .navigationBarLeading) {

                BackButton(action: {
                    showCommentPrompt = false
                   
                })
                .padding(.top, 10)


            }
        }
    }
}


struct FeelingSelectionView: View {
    @Binding var selectedCategory: Category?
    @ObservedObject var feelingData: FeelingData
    @Binding var showCommentPrompt: Bool
    @Binding var selectedFeeling: Feeling?
    @Binding var selectedDate: Date
    @Binding var userComment: String

   
   


    var body: some View {
        VStack {
            
            HStack(alignment: .center) {
                Text("Select a")
                    .font(.headline)
                Text("\(selectedCategory?.rawValue ?? "")")
                    .font(.headline)
                    .foregroundColor(Color.purple)
                Text("feeling: ")
                    .font(.headline)
                
            }
            if let category = selectedCategory, let feelings = feelingData.feelingsByCategory[category] {
               
                VStack {
                    

                    ForEach(feelings, id: \.name) { feeling in
                        Button(action: {
                            userComment = ""
                            //feelingData.recordFeeling(feeling: feeling, date: Date(), comment: userComment)
                            selectedCategory = nil
                            selectedFeeling = feeling
                            selectedDate = Date()
                            showCommentPrompt = true
                        }) {
                            VStack(alignment: .leading) {
                                Text(feeling.name)
                                    .font(.headline)
                                    .bold()
                                    .padding(2)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: false, vertical: true) // Add this line
                                Text(feeling.definition)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(3)
                                    .fixedSize(horizontal: false, vertical: true) // Add this line
                                  
                                   
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 65, alignment: .leading) // Add this line
                        }
                       
                    } .buttonStyle(.borderedProminent)
                        .tint(.gray)
                    
                    
                }
                
                .toolbar {
                    // 2
                    ToolbarItem(placement: .navigationBarLeading) {

                        BackButton(action: {
                            selectedCategory = nil
                            selectedFeeling = nil
                        })
                        .padding(.top, 10)

                    }
                }
                
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var appColorSettings = AppColorSettings()
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome: Bool = false
    
    @State private var selectedCategory: Category?
    @StateObject private var feelingData = FeelingData()
    @State private var showResult = false
    @State private var showCommentPrompt = false
    @State private var selectedFeeling: Feeling?
    @State private var selectedDate = Date()
    @State private var userComment = ""
    
    var body: some View {
        NavigationView {
            if !hasCompletedWelcome {
                WelcomeView()
            } else {
                ZStack {
                    if showResult {
                        if let feeling = selectedFeeling {
                            ResultView(feeling: feeling, date: selectedDate, comment: userComment)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        showResult = false
                                    }
                                }
                        }
                    } else if showCommentPrompt {
                        
                        CommentPromptView(feelingData: feelingData, showCommentPrompt: $showCommentPrompt, userComment: $userComment, showResult: $showResult, selectedFeeling: $selectedFeeling)
                        
                        
                    } else if selectedCategory != nil {
                        FeelingSelectionView(selectedCategory: $selectedCategory, feelingData: feelingData, showCommentPrompt: $showCommentPrompt, selectedFeeling: $selectedFeeling, selectedDate: $selectedDate, userComment: $userComment)
                        
                    } else {
                        VStack {
                            CategorySelectionView(selectedCategory: $selectedCategory)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                NavigationLink(destination: FeelingLogView(feelingData: feelingData)){
                                    Image(systemName: "list.bullet") // Use system image for Feeling Log
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: SettingsView().environmentObject(appColorSettings)) {
                                    Image(systemName: "gear") // Use system image for Settings
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        
                        
                        //                    VStack {
                        //                        NavigationLink(destination: FeelingLogView(feelingData: feelingData)){
                        //                            Text("Feeling Log")
                        //                                .font(.title)
                        //                                .foregroundColor(.white)
                        //                                .padding()
                        //                                .background(Color.blue)
                        //
                        //                        }
                        //                        .padding()
                        //
                        //
                        //
                        //                        CategorySelectionView(selectedCategory: $selectedCategory)
                        //                    }
                        //                    NavigationLink(destination: SettingsView()) {
                        //                        Text("Settings")
                        //                            .font(.title)
                        //                            .foregroundColor(.white)
                        //                            .padding()
                        //                            .background(Color.blue)
                        //                    }
                        //                    .padding()
                        
                        
                        
                        
                    }
                }
            }
        }
    }
    
}

//struct ContentView: View {
//    @State private var selectedCategory: Category?
//    @StateObject private var feelingData = FeelingData()
//    @State private var showResult = false
//    @State private var showCommentPrompt = false
//    @State private var selectedFeeling: Feeling?
//    @State private var selectedDate = Date()
//    @State private var userComment = ""
//
//    var body: some View {
//        NavigationView {
//            if showResult {
//                if let feeling = selectedFeeling {
//                    ResultView(feeling: feeling, date: selectedDate, comment: userComment)
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                showResult = false
//                            }
//                        }
//                }
//            } else if showCommentPrompt {
//                CommentPromptView(showCommentPrompt: $showCommentPrompt, userComment: $userComment, showResult: $showResult)
//            } else if selectedCategory != nil {
//                FeelingSelectionView(selectedCategory: $selectedCategory, feelingData: feelingData, showCommentPrompt: $showCommentPrompt, selectedFeeling: $selectedFeeling, selectedDate: $selectedDate)
//            } else {
//                CategorySelectionView(selectedCategory: $selectedCategory)
//            }
//        }
//
//    }
//}



struct ResultView: View {
    var feeling: Feeling
    var date: Date
    var comment: String

    var body: some View {
        VStack {
            Text("You are feeling: ")
                .font(.largeTitle)
                .padding()

            Text((feeling.name))
                .font(.largeTitle)
                .padding()
                .foregroundColor(.orange)

            Text("On \(date, formatter: dateFormatter)")
                .font(.title)
                .padding()

            Text("At \(date, formatter: timeFormatter)")
                .font(.title)
                .padding()

            if !comment.isEmpty {
                Text("Comment: \(comment)")
                    .font(.title)
                    .italic()
                    .padding()
                   
            }
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppColorSettings())
    }
}




