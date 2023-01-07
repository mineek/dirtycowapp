//
//  ContentView.swift
//  dirtycow
//
//  Created by Mineek on 03/01/2023.
//

import SwiftUI

struct ContentView: View {
    struct tweak: Identifiable {
        var id = UUID()
        var name: String
        var description: String
        var action: String
        var danger: Bool = false
    }


    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("DirtyCow")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                List(tweaks) { tweak in
                        VStack(alignment: .leading) {
                            Button(action: { 
                                if tweak.danger {
                                    // show a alert with a warning icon
                                    let alert = UIAlertController(title: "Warning", message: "This tweak is dangerous and should not be used because it can cause damage to your device. Are you sure you want to continue?", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                                        let alert = UIAlertController(title: "Please, use with caution", message: "Do not go be a crybaby if you break your device, this is your own fault and if you ask for help, we will laugh at you.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "I'm sure.", style: .default, handler: { action in
                                            runTweak(tweak.action)
                                        }))
                                        alert.addAction(UIAlertAction(title: "No, take me back.", style: .cancel, handler: nil))
                                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                                    }))
                                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                                }
                                else {
                                    runTweak(tweak.action)
                                }
                            }) {
                                if tweak.danger {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                        Text(tweak.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                } else {
                                    Text(tweak.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                
                Button(action: {
                    print("Respringing...")
                    guard let window = UIApplication.shared.windows.first else { return }
while true {
   window.snapshotView(afterScreenUpdates: false)
}
                }) {
                    Text("Respring")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(40)
                }
                .padding(.top, 50)
            }
        }.onAppear {
            let alert = UIAlertController(title: "Warning", message: "This app is for educational purposes only. I'm not responsible for any damage caused by this app.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Credits", style: .default, handler: { action in
                let credits = ["haxi0", "verygenericname"]
                let alert = UIAlertController(title: "Credits", message: "This app was made by Mineek, with help from \(credits.joined(separator: ", ")).", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            jsonTweaksInit()
        }
    }

    // helper functions
    // plistChange: Replace a single value in a plist
    // all use void overwriteFile(NSData *data, NSString *path); - DirtyCow
    func plistChange(plistPath: String, key: String, value: String) {
        let stringsData = try! Data(contentsOf: URL(fileURLWithPath: plistPath))
        // convert to plist
        let plist = try! PropertyListSerialization.propertyList(from: stringsData, options: [], format: nil) as! [String: Any]
        func changeValue(_ dict: [String: Any], _ key: String, _ value: String) -> [String: Any] {
            var newDict = dict
            for (k, v) in dict {
                if k == key {
                    newDict[k] = value
                } else if let subDict = v as? [String: Any] {
                    newDict[k] = changeValue(subDict, key, value)
                }
            }
            return newDict
        }
        // change value
        var newPlist = plist
        newPlist = changeValue(newPlist, key, value)
        // convert back to data
        let newData = try! PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)
        // write to file
        overwriteFile(newData, plistPath)
    }

    func stringsChange(stringsPath: String, key: String, value: String) {
        // read strings as data
        let stringsData = try! Data(contentsOf: URL(fileURLWithPath: stringsPath))
        // convert to plist
        let plist = try! PropertyListSerialization.propertyList(from: stringsData, options: [], format: nil) as! [String: Any]
        // change value
        var newPlist = plist
        newPlist[key] = value
        // convert back to data
        let newData = try! PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)
        // write to file
        overwriteFile(newData, stringsPath)
    }

    func runTweak(_ tweak: String) {
        switch tweak {
        case "keyswap":
            let garbage = Data(count: 100)
            let empty = garbage.base64EncodedData()
            overwriteFile(empty, "/System/Library/Audio/UISounds/key_press_click.caf")
            overwriteFile(empty, "/System/Library/Audio/UISounds/key_press_delete.caf")
            overwriteFile(empty, "/System/Library/Audio/UISounds/key_press_modifier.caf")
        case "hidedock":
            let hidedockdata = "YnBsaXN0MDDSAQIDBF8QF21hdGVyaWFsU2V0dGluZ3NWZXJzaW9uXGJhc2VNYXRlcmlhbBAC0QUGXxARbWF0ZXJpYWxGaWx0ZXJpbmfWBwgJCgsMDQ4TFBMTWnNhdHVyYXRpb25fEA9sdW1pbmFuY2VWYWx1ZXNfEA9sdW1pbmFuY2VBbW91bnRZYmx1ckF0RW5kWmJsdXJSYWRpdXNdYmFja2Ryb3BTY2FsZRABpA8QERIjP9KPXCj1wo8jv8mZmZmZmZojP9gAAAAAAAAjP+TMzMzMzM0QAAkIDSc0NjlNWmV3iZOerK6zvMXO19kAAAAAAAABAQAAAAAAAAAVAAAAAAAAAAAAAAAAAAAA2g==" // from base64
            let hidedock = Data(base64Encoded: hidedockdata)!
            overwriteFile(hidedock, "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockDark.materialrecipe")
            overwriteFile(hidedock, "/System/Library/PrivateFrameworks/CoreMaterial.framework/dockLight.materialrecipe")
        case "hidefolderbg":
            let garbage = Data(count: 100)
            let empty = garbage.base64EncodedData()
            overwriteFile(empty, "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderDark.materialrecipe")
            overwriteFile(empty, "/System/Library/PrivateFrameworks/SpringBoardHome.framework/folderLight.materialrecipe")
        case "hidehomebarbg":
            let garbage = Data(count: 100)
            let empty = garbage.base64EncodedData()
            overwriteFile(empty, "/System/Library/PrivateFrameworks/MaterialKit.framework/Assets.car")
        case "nosimcarriercustom":
            //stringsChange(stringsPath: "/System/Library/PrivateFrameworks/SystemStatusServer.framework/en_GB.lproj/SystemStatusServer-Telephony.strings", key: "NO_SIM", value: "banana")
            // ask user for a 6 character string
            let alert = UIAlertController(title: "Custom 'No SIM' carrier", message: "Enter a 6 character string to use as the 'No SIM' carrier.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "pwned."
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                let text = alert.textFields![0].text!
                if text.count == 6 {
                    stringsChange(stringsPath: "/System/Library/PrivateFrameworks/SystemStatusServer.framework/en_GB.lproj/SystemStatusServer-Telephony.strings", key: "NO_SIM", value: text)
                } else {
                    let alert = UIAlertController(title: "Invalid string", message: "The string must be 6 characters long.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
        default:
            runJSONTweak(tweak)
        }
    }

    // tweak list
    @State var tweaks = [
        tweak(name: "Silent keyboard", description: "Make keyboard silent", action: "keyswap", danger: false),
        tweak(name: "Hide dock", description: "Hide dock", action: "hidedock", danger: false),
        tweak(name: "Hide folder background", description: "Hide folder background", action: "hidefolderbg", danger: false),
        tweak(name: "Hide home bar", description: "Hide home bar", action: "hidehomebarbg", danger: false),
        tweak(name: "Custom 'No SIM' carrier", description: "Custom 'No SIM' carrier", action: "nosimcarriercustom", danger: false),
    ]
    /*
    {
        "tweaks": [
            {
                "name": "Tweak name",
                "description": "Tweak description",
                "actions": [
                    {
                        "file": "file to replace",
                        "data": "base64 encoded data"
                    }
                ],
                "actionType": "replace" // replace, keyedit
            },
            {
                "name": "Tweak name keyedit",
                "description": "Tweak description",
                "actions": [
                    {
                        "file": "file to edit",
                        "data": "key to edit:value it becomes"
                    }
                ],
                "actionType": "keyedit" // replace, keyedit
            }
        ]
    }
    */

    struct tweakData: Codable {
        let tweaks: [jsonTweak]
    }

    struct jsonTweak: Codable {
        let name: String
        let description: String
        let actions: [jsonAction]
        let actionType: String
    }

    struct jsonAction: Codable {
        let file: String
        let data: String
    }

    func runJSONTweak(_ tweak: String) {
        // get the JSON file
        let url = URL(string: "https://raw.githubusercontent.com/mineek/dirtycowapp/main/tweaks.json")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            guard let tweakData = try? JSONDecoder().decode(tweakData.self, from: data) else {
                print("Error: Couldn't decode data into tweakData")
                return
            }
            // find the tweak
            for jsonTweak in tweakData.tweaks {
                if jsonTweak.name == tweak {
                    // run the tweak
                    for jsonAction in jsonTweak.actions {
                        let file = jsonAction.file
                        /*let data = Data(base64Encoded: jsonAction.data)!
                        overwriteFile(data, file)*/
                        switch jsonTweak.actionType {
                        case "replace":
                            let data = Data(base64Encoded: jsonAction.data)!
                            overwriteFile(data, file)
                        case "keyedit":
                            let key = jsonAction.data.components(separatedBy: ":")[0]
                            let value = jsonAction.data.components(separatedBy: ":")[1]
                            plistChange(plistPath: file, key: key, value: value)
                        default:
                            print("Invalid action type")
                        }
                    }
                }
            }
        }
        task.resume()
    }

    func jsonTweaksInit() {
        // get the JSON file
        let url = URL(string: "https://raw.githubusercontent.com/mineek/dirtycowapp/main/tweaks.json")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            guard let tweakData = try? JSONDecoder().decode(tweakData.self, from: data) else {
                print("Error: Couldn't decode data into tweakData")
                return
            }
            // add the tweaks to the tweak list
            for jsonTweak in tweakData.tweaks {
                tweaks.append(tweak(name: jsonTweak.name, description: jsonTweak.description, action: jsonTweak.name, danger: false))
            }
        }
        task.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
