//
//  ContentView.swift
//  Make Your Chord
//
//  Created by SeungWoo Mun on 2021/06/11.
//

import SwiftUI
// import UniformTypeIdentifiers

struct ContentView: View {
    
//    @State var fileName = ""
//    @State var openFile = false
//    @State var saveFile = false
    
    var body: some View {
        MainView()
//        VStack {
//
//            Text(fileName)
//                .fontWeight(.bold)
//
//            Button(action: {openFile.toggle()}, label: {
//                Text("Open")
//            })
//            Button(action: {saveFile.toggle()}, label: {
//                Text("Save")
//            })
//            .fileImporter(isPresented: $openFile, allowedContentTypes: [.audio]) { (res) in
//
//                do {
//                    let fileUrl = try res.get()
//
//                    print(fileUrl)
//
//                    self.fileName = fileUrl.lastPathComponent
//                }
//                catch {
//                    print("error reading docs")
//                    print(error.localizedDescription)
//                }
//            }
//
//            // to save file
//            .fileExporter(isPresented: $saveFile, document: Doc(url: Bundle.main.path(forResource: "Airplane_1", ofType: "wav")!), contentType: .audio) { (res) in
//                do {
//                    let fileUrl = try res.get()
//
//                    print(fileUrl)
//                }
//                catch {
//                    print("cannot save doc")
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct Doc: FileDocument {
//
//    var url: String
//
//    static var  readableContentTypes: [UTType]{[.audio]}
//
//    init(url: String) {
//        self.url = url
//    }
//
//    init(configuration: ReadConfiguration) throws {
//        // desetilize the content
//        // se don't need to read contents
//
//        url = ""
//    }
//
//    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//        // retuning and saving file
//
//        let file = try! FileWrapper(url: URL(fileURLWithPath: url), options: .immediate)
//
//        return file
//    }
//}
