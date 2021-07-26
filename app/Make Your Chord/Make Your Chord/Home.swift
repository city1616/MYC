//
//  Home.swift
//  Make Your Chord
//
//  Created by SeungWoo Mun on 2021/06/10.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation
import AVFoundation

struct Home: View {
    
    
    @Binding var selectedTab: String

    init(selectedTab: Binding<String>) {
        self._selectedTab = selectedTab
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $selectedTab){
            HomePage()
                .tag("Home")
            History()
                .tag("History")
            Settings()
                .tag("Settings")
            Help()
                .tag("Help")
            Sheet()
                .tag("Sheet")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Sheet()
    }
}

struct down: View {
    @StateObject var downloadModel = DownloadTaskModel()
    @State var urlText = "http://127.0.0.1:8080/Airplane.pdf"
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                TextField("URL", text: $urlText)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                
                // Download Button...
                Button(action: {downloadModel.startDownload(urlString: urlText)}, label: {
                    Text("Download")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
                .padding(.top)
            }
            .padding()
            // Navigation Bar Title
            .navigationTitle("Download Task")
        }
        // Always Light Mode...
        .preferredColorScheme(.light)
        // Alert
        .alert(isPresented: $downloadModel.showAlert, content: {
            Alert(title: Text("Message"), message: Text(downloadModel.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                downloadModel.showDownloadProgress = false
            }))
        })
        .overlay(
            ZStack {
                if downloadModel.showDownloadProgress {
                    DownloadProgressView(progress: $downloadModel.downloadProgress)
                        .environmentObject(downloadModel)
                }
            }
        )
    }
}

struct HomePage: View {
    
    var body: some View{
        
        NavigationView{
            
            VStack(alignment: .leading,spacing: 20){
                
                Image("pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width - 50, height: 400)
                    .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 5, content: {
                    
                    Text("Make Your Chord")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("음악 파일을 악보로 변환시켜주는 프로그램")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                })
            }
            .navigationTitle("Home")
        }
    }
}

struct History: View {
    
    var body: some View{
    
        NavigationView{
            
            Text("History")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("History")
        }
    }
}

struct Sheet: View {
    
    @Environment(\.colorScheme) var scheme
    
    @State var selectedImage: Image? = Image("")
    // @State private var document: MessageDocument = MessageDocument(message: "Hello, World!")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State var fileName = ""
    @State var title = ""
    @State var openFile = false
    @State var saveFile = false
    
    @State var alert = false
    
    @StateObject var downloadModel = DownloadTaskModel()
    @State var urlText = ""
    
    @State var downview: Bool = false
    
    @State var rotateBall = true
    @State var showPopUp = false
    
    @State var soundEffect: AVAudioPlayer?

    var body: some View {
        
        NavigationView {
            
            // 선택한 음악 제목 출력, 음악 선택 버튼 , 음악 시작 버튼, 음악 정지 버튼, 변환 버튼, download 버튼
            VStack(spacing: 30) {
                
                Text("SELECTED MUSIC")
                    .fontWeight(.bold)
                
                Text(title)
                    .fontWeight(.bold)
                
                Button(action: { openFile.toggle() }, label: {
                    Text("SELECT MUSIC")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 60)
                        .background(Color("Purple"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
//                Button(action: {saveFile.toggle()}, label: {
//                    Text("Save")
//                })
                .fileImporter(isPresented: $openFile, allowedContentTypes: [.audio]) { (res) in
                    
                    do {
                        let fileUrl = try res.get()
                        
                        print(fileUrl)
                        
                        self.fileName = fileUrl.lastPathComponent
                        title = String(fileName.dropLast(4))
                    }
                    catch {
                        print("error reading docs")
                        print(error.localizedDescription)
                    }
                }
                
                // to save file
                .fileExporter(isPresented: $saveFile, document: Doc(url: Bundle.main.path(forResource: "Mary_had_a_little_lamb", ofType: "wav")!), contentType: .audio) { (res) in
                    do {
                        let fileUrl = try res.get()
                        
                        print(fileUrl)
                    }
                    catch {
                        print("cannot save doc")
                        print(error.localizedDescription)
                    }
                }
                
                // 음악 시작, 정지 버튼
                HStack(spacing: 20) {
                    
                    // 시작 버튼
                    Button(action: {
                        let url = Bundle.main.url(forResource: title, withExtension: "wav")
                        if let url = url{
                            //code
                            
                            do {
                                soundEffect = try AVAudioPlayer(contentsOf: url)
                                guard let sound = soundEffect else { return }
                                
                                //sound.prepareToPlay()
                                sound.play()
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }, label: {
                        Image(systemName: "play.fill")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(Color("Purple"))
                    })
                    
                    // 정지 버튼
                    Button(action: {
                        let url = Bundle.main.url(forResource: title, withExtension: "wav")
                        if let url = url{
                            //code
                            
                            do {
                                soundEffect = try AVAudioPlayer(contentsOf: url)
                                guard let sound = soundEffect else { return }
                                
                                //sound.prepareToPlay()
                                sound.stop()
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }, label: {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 29, weight: .semibold))
                            .foregroundColor(Color("Purple"))
                    })
                }
                
                // 변환 버튼, download 버튼
                
                // 변환 버튼
                Button(action: {
                    withAnimation(.spring()){showPopUp.toggle()}

                    // sendAudio(audioPath: Bundle.main.url(forResource: "Airplane_1", withExtension: "wav")!)
                    // convert image into base 64
                    // title = 노래 제목(확장자 제거)
                    let title: String = String(fileName.dropLast(4))
                    
                    guard let wav_data = try? Data(contentsOf: Bundle.main.url(forResource: title, withExtension: "wav")!) else { return }
                    let wav_Str: String = wav_data.base64EncodedString()
                    let title_Str = title.toBase64()
                    
                    // send request to server
                    guard let url: URL = URL(string: "http://172.30.1.19:8080/index.php") else {
                        print("invalid URL")
                        return
                    }

                    // create parameters
                    let paramStr: String = "wav_Str=\(wav_Str)&title=\(title_Str)"
                    let paramData: Data = paramStr.data(using: .utf8) ?? Data()

                    var urlRequest: URLRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "POST"
                    urlRequest.httpBody = paramData

                    // required for sending large data
                    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                    // send the request
                    URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data, response, error) in guard let data = data else {
                        print("invalid data")
                        showPopUp.toggle()
                        return
                    }
                    // show response in string
                    let responseStr: String = String(data: data, encoding: .utf8) ?? ""
                    print(responseStr)
                    alert.toggle()
                    showPopUp.toggle()
                    })
                    .resume()
                    
                    // self.alert.toggle()
                }, label: {
                    Text("  GO TO MUSIC SHEET  ")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color("Purple"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
                .alert(isPresented: $alert) {
                    Alert(title: Text("Alert"), message: Text("Success !!!"), dismissButton: .default(Text("Ok")))
                }
                
                // Download 버튼
                Button(action: {
                    
                    urlText = "http://172.30.1.19:8080/MYC/code/pdf/" + title + ".pdf"
                    print(urlText)
                    downloadModel.startDownload(urlString: urlText)
                }, label: {
                    Text("          DOWNLOAD          ")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color("Purple"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
            }
            
            .navigationTitle("Sheet")
        }
        // Always Light Mode...
        .preferredColorScheme(.light)
        // Alert
        .alert(isPresented: $downloadModel.showAlert, content: {
            Alert(title: Text("Message"), message: Text(downloadModel.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                downloadModel.showDownloadProgress = false
            }))
        })
        .overlay(
            ZStack {
                if downloadModel.showDownloadProgress {
                    DownloadProgressView(progress: $downloadModel.downloadProgress)
                        .environmentObject(downloadModel)
                }
            }
        )
        .overlay(
            ZStack {
                if showPopUp {
                    Color.primary.opacity(0.2)
                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation(.spring()){showPopUp.toggle() }
//                        }
                    DribbleAnimatedView(showPopup: $showPopUp, rotateBall: $rotateBall)
                }
            }
        )
    }
}

struct Doc: FileDocument {
    
    var url: String
    
    static var  readableContentTypes: [UTType]{[.audio]}
    
    init(url: String) {
        self.url = url
    }
    
    init(configuration: ReadConfiguration) throws {
        // desetilize the content
        // se don't need to read contents
        
        url = ""
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        // retuning and saving file
        
        let file = try! FileWrapper(url: URL(fileURLWithPath: url), options: .immediate)
        
        return file
    }
}

struct Settings: View{
    
    var body: some View{
        
        NavigationView{
    
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Settings")
        }
    }
}

struct Help: View{
    
    var body: some View{
        
        NavigationView{
    
            Text("Help")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .navigationTitle("Help")
        }
    }
}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}

struct DribbleAnimatedView: View {
    
    // Color Scheme for dark Mode adoption
    @Environment(\.colorScheme) var scheme
    
    // Properties
    @Binding var showPopup: Bool
    @Binding var rotateBall: Bool
    
    // Animation Properties
    @State var animateBall = false
    @State var animateRotation = false
    
    var body: some View {
        
        ZStack {
            (scheme == .dark ? Color.black : Color.white)
                .frame(width: 150, height: 150)
                .cornerRadius(14)
                // Shadows
                .shadow(color: Color.primary.opacity(0.07), radius: 5, x: 5, y: 5)
                .shadow(color: Color.primary.opacity(0.07), radius: 5, x: -5, y: -5)
            // Ball Shadow
            Circle()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 40)
            // Rotating in X Axis
                .rotation3DEffect(
                    .init(degrees: 60),
                    axis: (x: 1, y: 0, z: 0.0),
                    anchor: .center,
                    anchorZ: 0.0,
                    perspective: 1.0)
                .offset(y: 35)
                .opacity(animateBall ? 1 : 0)
            
            Image("dribble")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .rotationEffect(.init(degrees: rotateBall && animateRotation ? 360 : 0))
                .offset(y: animateBall ? 10 : -25)
        }
        .onAppear(perform: {
            doAnimation()
        })
    }
    func doAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
            animateBall.toggle()
        }
        withAnimation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false)) {
            animateRotation.toggle()
        }
    }
}
