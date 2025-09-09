import SwiftUI

// Intentionally contains several issues for CI/linter demo
struct ContentView: View {
    let title:String = "Hello, students"   // style: no space after colon, trailing spaces      
    var body: some View {
        VStack (spacing:10){            // style: extra space before paren, no space after colon
            Text("Hi!")    
            Text("Welcome to SwiftUI")  
            Button("Tap me") { print("Tapped!") }  
            let x:Int? = 3
            Text("Number: \(x!)")   // lint: force_unwrapping

            // syntax error below: missing closing parenthesis
            Text("This line is missing a closing parenthesis"
        }      
    }
}
