//
//  Node.m
//  MyEngine
//
//  Created by Максим Хацкевич on 29.05.12.
//  Copyright (c) 2012 max@nebitech.ru. All rights reserved.
//

#import "Node.h"

@implementation Node

@synthesize rotation = _rotation;
@synthesize position = _position;
@synthesize scale = _scale;
@synthesize zOrder = _zOrder;

@synthesize parentRotation = _parentRotation;
@synthesize parentPosition = _parentPosition;
@synthesize parentScale = _parentScale;

@synthesize children = _children;
@synthesize parent = _parent;
@synthesize context = _context;
@synthesize glView = _glView;

- (id)init
{
    if(self = [super init])
    {
        _rotation = 0;
        
        _position.x = 0;
        _position.y = 0;
        
        _scale.x = 1;
        _scale.y = 1;
        
        _parentRotation = 0;
        _parentPosition = GLKVector2Make(0, 0);
        _parentScale = GLKVector2Make(1, 1);
        
        _zOrder = 0;
        
        _children = [NSMutableArray array];
        _parent = NULL;
        _context = NULL;
        
        _glView = NULL;
    }
    
    return self;
}

- (void)setupGL
{
    //
}

- (void)prepareTransformation
{
    //
}

- (void)draw
{
    //
}

- (void)drawAll
{
    [self draw];
    
    //draw children:
    for(uint i = 0; i < _children.count; i++ )
    {
        [[_children objectAtIndex:i] drawAll];
    }
}

- (void)addChild: (Node *)childNode onLayer: (int)targetLayer
{
    if (childNode)
    {
        [childNode setZOrder:targetLayer];
        [childNode setParent:self];
        [childNode prepareTransformation];
        
        if(![_children containsObject:childNode])
        {
            [_children addObject:childNode];
            
            //sort children
            [_children sortUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 zOrder] > [obj2 zOrder]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 zOrder] < [obj2 zOrder]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
        }
    }
}

- (void)removeChild: (Node *)childNode
{
    [_children removeObject:childNode];
}

@end
