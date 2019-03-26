//
//  AppDelegate.swift
//  Noisé
//
//  Created by Alex Hofsteede on 1/23/15.
//  Copyright (c) 2015 Alex Hofsteede. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    var sounds:[String: [String: AnyObject]] = ["leafblower": ["name": "leafblower", "playing": false]]
    @IBOutlet var mainMenu: NSMenu?;
    var statusItem:NSStatusItem?;

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1); // Workaround, for CGFloat(NSVariableStatusItemLength) which causes linker error
        self.statusItem!.image = NSImage(named: "BarIcon");
        self.statusItem!.menu = self.mainMenu;
        self.statusItem!.highlightMode = false;
        self.statusItem!.target = self;
        
        self.mainMenu!.delegate = self;
        
        var views:NSArray? = [];
        NSBundle.mainBundle().loadNibNamed("MainMenu", owner: self, topLevelObjects:&views);
        for view in views! {
            if view is NSView {
                let imageView:NSImageView = (view.subviews[0] as NSImageView);
                imageView.image = NSImage(named: "Leaf");
                
                let slider:NSSlider = (view.subviews[1] as NSSlider);
                slider.minValue = 0.0;
                slider.maxValue = 1.0;
                slider.floatValue = 0.0;
                slider.target = self;
                slider.action = "sliderChanged:"
                
                var menuItem:NSMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "");
                menuItem.representedObject = Array(self.sounds.keys)[0];
                menuItem.view = view as? NSView;
                menuItem.target = self;
                mainMenu?.addItem(menuItem);
                break;
            }
        }
        
    }
    
    func sliderChanged(sender:NSSlider)
    {
        var name:String = sender.enclosingMenuItem?.representedObject as String;
        var dict:[String: AnyObject] = self.sounds[name]!;
        if (sender.floatValue > 0.0 && !(dict["playing"] as Bool)) {
            println("playing new sound");
            let sound:NSSound = NSSound(named: name)!;
            sound.loops = true;
            sound.volume = sender.floatValue;
            dict["sound"] = sound;
            ((self.sounds[name]) as [String: AnyObject])["playing"] = true;
            sound.play();
        } else if(dict["playing"] as Bool) {
            println("value is \(sender.floatValue)");
            if(sender.floatValue == 0.0) {
                println("stopping");
                (dict["sound"] as NSSound).stop();
            } else {
                 println("volume");
                (dict["sound"] as NSSound).volume = sender.floatValue;
            }
        }
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

