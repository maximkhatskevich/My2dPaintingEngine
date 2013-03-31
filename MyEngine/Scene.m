//
//  Scene.m
//  MyEngine
//
//  Created by Максим Хацкевич on 29.05.12.
//  Copyright (c) 2012 max@nebitech.ru. All rights reserved.
//

#import "Scene.h"

@implementation Scene

@synthesize bgColor = _bgColor;

+ (id)createWithGLView: (GLKView *)targetView
{
    return [[Scene alloc] initWithGLView:targetView];
}

- (id)initWithGLView: (GLKView *)targetView
{
    if(self = [self init])
    {
        [self setGlView:targetView];
        [self setupGL];
    }
    
    return self;
}

- (Sprite *)spriteWithTextureFile: (NSString *)pngFileName
{
    return [Sprite createWithGLView:self.glView andTextureFile:pngFileName];
}

- (void)setupGL
{
    GLKView *view = self.glView;
    view.context = self.context;
    view.delegate = self;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
}


- (void)tearDownGL
{
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
    
    self.context = nil;
}
    
- (id)init
{
    if(self = [super init])
    {
        _bgColor.r = 0.0;
        _bgColor.g = 1;
        _bgColor.b = 0.0;
        _bgColor.a = 1.0;
        
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        if (!self.context) {
            NSLog(@"Failed to create ES context");
        }
    }
    
    return self;
}

- (void)draw
{
    //в сцене рисуем только фон:
    glClearColor(_bgColor.r,
                 _bgColor.g,
                 _bgColor.b,
                 _bgColor.a);
    glClear(GL_COLOR_BUFFER_BIT);
}

#pragma mark - GLKViewDelegate

//сигнал от GLKView о том, что пора перерисовывать 
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self drawAll];
}

@end
