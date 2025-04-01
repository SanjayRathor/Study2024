//
//  ViewController.swift
//  JSToNavtive
//
//  Created by Sanjay Singh Rathor on 06/03/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import UIKit
import JavaScriptCore
import CJavaScriptCore

class ViewController: UIViewController {

    var jsContext: JSContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeJS()
        
        
        helloWorld()
    }
    
    func helloWorld() {
        
        
      
//        let  c:JSValue = [_context[@"testClass"] constructWithArguments:@[]];
//        [c invokeMethod:@"toto" withArguments:@[]];
//
//
//        JSValue* c = [_context[@"testClass"] constructWithArguments:@[]];
//        [c invokeMethod:@"toto" withArguments:@[]];
        
        if let variableHelloWorld = self.jsContext.objectForKeyedSubscript("HLSManifest().parseString()") {
           
            
            variableHelloWorld.invokeMethod("parseString", withArguments: ["asda"])
            
            print(variableHelloWorld.toString() ?? "")
        }
    }
    
    
    func initializeJS() {
        self.jsContext = JSContext()
        
        // Add an exception handler.
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString() ?? "")
            }
        }
        
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "mfl", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                self.jsContext.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        self.jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        _ = self.jsContext.evaluateScript("consoleLog")
    }
    
    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
           print("\nJS Console:", logMessage)
    }
       
}


