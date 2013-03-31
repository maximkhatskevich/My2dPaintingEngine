//
//  Node.h
//  MyEngine
//
//  Created by Максим Хацкевич on 29.05.12.
//  Copyright (c) 2012 max@nebitech.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
//
//typedef struct
//{
//    float rotation;
//    Vector2 position;
//    Vector2 scale;
//} SpriteParams;

@interface Node : NSObject

@property float rotation;
@property GLKVector2 position;
@property GLKVector2 scale;
@property int zOrder; //relative to parent!!!

@property float parentRotation;
@property GLKVector2 parentPosition;
@property GLKVector2 parentScale;

@property(nonatomic, retain) NSMutableArray *children;
@property(nonatomic, retain) Node *parent;
@property(nonatomic, retain) EAGLContext *context;
@property (nonatomic, retain) GLKView *glView;

- (void)setupGL;
- (void)prepareTransformation;
- (void)addChild: (Node *)childNode onLayer: (int)targetLayer;
- (void)removeChild: (Node *)childNode;
- (void)drawAll;
- (void)draw;

@end
