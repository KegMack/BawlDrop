//
//  GameViewController.swift
//  CandyDrop
//
//  Created by User on 4/17/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

extension SKNode {
//  class func unarchiveFromFile(file : String) -> SKNode? {
//    if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
//      var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
//      var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//      
//      archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//      let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
//      archiver.finishDecoding()
//      return scene
//    } else {
//      return nil
//    }
//  }
}

class GameViewController: UIViewController {
  
  let motionManager = CMMotionManager()
  
//  override func viewDidLoad() {
  //    super.viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
    // Configure the view.
    var scene = GameScene(size: self.view.frame.size)
    let skView = self.view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = .AspectFill
    
    skView.presentScene(scene)
    
    self.motionManager.accelerometerUpdateInterval = 0.05
    scene.motionManager = self.motionManager
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.motionManager.startAccelerometerUpdates()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.motionManager.stopAccelerometerUpdates() 
  }
  
  override func shouldAutorotate() -> Bool {
    return true 
  }
  
  override func supportedInterfaceOrientations() -> Int {
//    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
//    } else {
//      return Int(UIInterfaceOrientationMask.All.rawValue)
//    }
    return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
