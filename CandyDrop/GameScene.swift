//
//  GameScene.swift
//  CandyDrop
//
//  Created by User on 4/17/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

import SpriteKit
import CoreMotion
import GLKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  
  // multiplier for bawl movement distance
  let displacementMagnitudeCoefficient: CGFloat = 8
  let ballCategory: UInt32 = 0x1 << 3
  let holeCategory: UInt32 = 0x1 << 4
  
  var motionManager: CMMotionManager!
  var previousFrameTime: CFTimeInterval!

  var hole: SKSpriteNode!
  var bawl: SKSpriteNode!
  var background: SKSpriteNode!
  
//  Neutral orientation for Accelerometer  -- adapted from Wenderlich SpriteKit tutorial
//  var neutralX = GLKVector3Make(0.6, 0, -0.9)
//  var neutralY = GLKVector3Make(0, 1, 0)
//  var neutralZ: GLKVector3! {get {return (GLKVector3CrossProduct(neutralX, neutralY)) }}
  
  override func didMoveToView(view: SKView) {
    self.previousFrameTime = CFAbsoluteTimeGetCurrent()
    self.physicsWorld.contactDelegate = self
    self.initBackground()
    self.addChild(self.background)
    
    self.initBawl()
    self.addChild(self.bawl)
    
 
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch in (touches as! Set<UITouch>) {
      let location = touch.locationInNode(self)
      let jumpAnimation = SKAction()
      

    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    moveNodeUsingAccelerometerData(self.bawl)
    self.previousFrameTime = currentTime
  }
  
  //MARK: Initialization Methods
  
  func initBawl() {
    self.bawl = SKSpriteNode(imageNamed: "BlueBawl.png")
    self.bawl.position = CGPointMake(self.size.width/2, self.size.height/2)
    self.bawl.physicsBody = SKPhysicsBody(circleOfRadius: bawl.size.width/2)
    self.bawl.physicsBody?.contactTestBitMask = self.ballCategory
    self.bawl.xScale = 2.5
    self.bawl.yScale = 2.5
    let bawlRotateAction = SKAction.rotateByAngle(CGFloat(M_PI/32), duration:0.03)
    self.bawl.runAction(SKAction.repeatActionForever(bawlRotateAction))
  }
  
  func initHole() {
    self.hole = SKSpriteNode(imageNamed: "Hole.png")
    self.hole.zPosition = 1
    self.hole.xScale = 5.0
    self.hole.yScale = 5.0
    self.hole.physicsBody = SKPhysicsBody(circleOfRadius: self.hole.frame.width/2)
    self.hole.physicsBody?.contactTestBitMask = self.holeCategory
    self.hole.physicsBody?.collisionBitMask = UInt32(0)
    self.hole.position.x = self.background.frame.size.width/2
    self.hole.position.y = self.background.frame.size.height/2
    let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI/32), duration:0.03)
    self.hole.runAction(SKAction.repeatActionForever(rotateAction))
  }
  
  func initBackground() {
    self.background = SKSpriteNode(imageNamed: "Spaceship_Earth_tiles.jpg")
    self.background.name = "background"
  //  self.background.anchorPoint = CGPointZero
    self.background.anchorPoint = self.frame.origin
  //  self.background.position = CGPointZero
    self.background.position = self.frame.origin
    self.background.zPosition = -10.0
    self.background.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.background.frame)
    self.background.physicsBody?.contactTestBitMask = UInt32(0)
    self.initHole()
    self.background.addChild(self.hole)
    self.addRowOfBlocksTo(self.background, atYPosition: (self.background.frame.height / 12))
    self.addRowOfBlocksTo(self.background, atYPosition: 2 * self.background.frame.height / 5)
    self.addRowOfBlocksTo(self.background, atYPosition: 3 * self.background.frame.height / 4 )
  }
  
  func addRowOfBlocksTo(node: SKSpriteNode, atYPosition y: CGFloat) {
    for i in 0...10 {
      var block = self.block()
      block.position.y = y
      block.position.x = CGFloat(i * 150)
      block.zPosition = 1
      node.addChild(block)
    }
  }
  
  func block() -> SKShapeNode {
    let blockSize = CGSizeMake(100, 100)
    var blockNode = SKShapeNode(rectOfSize: blockSize)
    blockNode.fillColor = UIColor.brownColor()
    blockNode.physicsBody = SKPhysicsBody(rectangleOfSize: blockSize)
    blockNode.physicsBody?.contactTestBitMask = UInt32(0)
    return blockNode
  }
  
  
  
  //MARK: Accelerometric Methods
  
  
  func moveNodeUsingAccelerometerData(node: SKNode) {
    if let accelerometerData = self.motionManager.accelerometerData {
      let displacement = CGPointMake(displacementMagnitudeCoefficient * CGFloat(accelerometerData.acceleration.y), displacementMagnitudeCoefficient * -CGFloat(accelerometerData.acceleration.x))
      let viewCenter = CGPointMake(self.frame.midX, self.frame.midY)
      
      // right side start/stop scrolling
      if self.background.position.x <= self.frame.size.width - self.background.size.width {
        self.background.position.x = self.frame.size.width - self.background.size.width
        if self.bawl.position.x < viewCenter.x {
          self.bawl.position.x = viewCenter.x + 1
          self.background.position.x -= displacement.x
        } else {
          self.bawl.position.x += displacement.x
        }
      }
      // left side
      else if self.background.position.x >= 0 {
        self.background.position.x = 0
        if self.bawl.position.x > viewCenter.x {
          self.bawl.position.x = viewCenter.x - 1
          self.background.position.x -= displacement.x
        } else {
          self.bawl.position.x += displacement.x
        }
      }
      //default
      else {
        self.background.position.x -= displacement.x
      }

      // bottom
      ////////////  Begin Bullshit ///////////////
      let offset:CGFloat = 0  /// totally f'd up here.  It should be 0 and unnecessary.... stupid confusing Spritekit
      ////////////   End Bullshit //////////////////
      
      if self.background.position.y >= offset {
        self.background.position.y = offset
        if self.bawl.position.y > viewCenter.y {
          self.bawl.position.y = viewCenter.y - 1
          self.background.position.y -= displacement.y
        } else {
          self.bawl.position.y += displacement.y
        }
      }
      //top
      else if self.background.position.y <= self.frame.size.height - self.background.size.height - offset {
        self.background.position.y = self.frame.size.height - self.background.size.height - offset
        if self.bawl.position.y < viewCenter.y {
          self.bawl.position.y = viewCenter.y + 1
          self.background.position.y -= displacement.y
        } else {
          self.bawl.position.y += displacement.y
        }
      }
      //      default
      else {
        self.background.position.y -= displacement.y
     }
      
        
        

    
      //Following lines shamelessly taken/adapted from Wenderlich Spritekit Tutorial
//      var rawAccelerometerData = GLKVector3Make(Float(accelerometerData.acceleration.x), Float(accelerometerData.acceleration.y), Float(accelerometerData.acceleration.z))
//      if !GLKVector3AllEqualToScalar(rawAccelerometerData, 0) {
//        var acceleration2D = CGPointZero
//        acceleration2D.x = CGFloat(GLKVector3DotProduct(rawAccelerometerData, self.neutralZ))
//        acceleration2D.y = CGFloat(GLKVector3DotProduct(rawAccelerometerData, self.neutralX))
//        //acceleration2D = CGPoint.Normalize(acceleration2D)
//        println("\(acceleration2D)")
//        node.position.x += acceleration2D.x
//        node.position.y += acceleration2D.y
//        
//      }
    }
  }
  
  //MARK: Physics Delegate Methods
  func didBeginContact(contact: SKPhysicsContact) {
  
    let collision = (contact.bodyA.contactTestBitMask | contact.bodyB.contactTestBitMask);
    if collision == (holeCategory | ballCategory) {
      let joint = SKPhysicsJointPin.jointWithBodyA(contact.bodyA, bodyB: contact.bodyB, anchor: contact.contactPoint)
      self.physicsWorld.addJoint(joint)
      let zoomAction = SKAction.scaleBy(10, duration: 4)
      self.hole.runAction(zoomAction)
    }
  }
  
  
  
}


// CGPoint Extensions stolen from lionadi.wordpress.com/tag/apple/
extension CGPoint {
  
  static func Mult(let v: CGPoint , let s: CGFloat) -> CGPoint {
    return CGPointMake(v.x * s, v.y * s);
  }
  
  static func Normalize(let v: CGPoint) -> CGPoint {
    return CGPoint.Mult(v, s: 1.0 / CGPoint.Length(v));
  }
  
  static func Length(let v: CGPoint) -> CGFloat {
    return CGFloat(sqrtf(Float(CGPoint.LengthSQ(v))));
  }
  
  static func Dot(let v1 : CGPoint, let v2 : CGPoint) -> CGFloat {
    return v1.x * v2.x + v1.y * v2.y;
  }
  
  static func LengthSQ(let v: CGPoint) -> CGFloat {
    return CGPoint.Dot(v, v2: v);
  }
  
}
