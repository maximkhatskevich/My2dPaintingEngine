//
//  Sprite.m
//  MyEngine
//
//  Created by Максим Хацкевич on 29.05.12.
//  Copyright (c) 2012 max@nebitech.ru. All rights reserved.
//

#import "Sprite.h"
#import <GLKit/GLKit.h>

Vertex vertices[] = {
    {{1, -1, 1}, {1, 1, 1, 1}, {1, 0}},
    {{1, 1, 1}, {1, 1, 1, 1}, {1, 1}},
    {{-1, 1, 1}, {1, 1, 1, 1}, {0, 1}},
    {{-1, -1, 1}, {1, 1, 1, 1}, {0, 0}}
};

const GLubyte vertexIndices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation Sprite

@synthesize fovyRadians = _fovyRadians;
@synthesize nearOffset = _nearOffset;
@synthesize farOffset = _farOffset;
@synthesize defaultZOffset = _defaultZOffset;
@synthesize layerZOffset = _layerZOffset;

@synthesize effect = _effect;

+ (id)createWithGLView: (GLKView *)targetView andTextureFile: (NSString *)pngFileName
{
    return [[Sprite alloc] initWithGLView:targetView andTextureFile:pngFileName];
}

- (id)initWithGLView: (GLKView *)targetView andTextureFile: (NSString *)pngFileName
{
    if(self = [self init])
    {
        [self setGlView:targetView];
        [self setContext:targetView.context];
        [self setupGL];
        [self loadTexture:pngFileName];
    }
    
    return self;
}

- (void)loadTexture: (NSString *)pngFileName
{
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES],
                              GLKTextureLoaderOriginBottomLeft, 
                              nil];
    
    //NSString *str = @"tile_floor";
    
    NSError *error;    
    NSString *path = [[NSBundle mainBundle] pathForResource:pngFileName ofType:@"png"];
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    }
    self.effect.texture2d0.name = info.name;
    self.effect.texture2d0.enabled = true;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_CULL_FACE);
    
    self.effect = [[GLKBaseEffect alloc] init];
    
    //===
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vertexIndices), vertexIndices, GL_STATIC_DRAW);
    
    // New lines (were previously in draw)
    glEnableVertexAttribArray(GLKVertexAttribPosition);        
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, position));
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, color));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, texCoord));
    
    // New line
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    self.context = nil;
}

- (id)init
{
    if(self = [super init])
    {
        _fovyRadians = 65.0;
        _nearOffset = 4.0;
        _farOffset = 10.0;
        _defaultZOffset = -6.0;
        _layerZOffset = 0.01;
    }
    
    return self;
}

- (void)dealloc
{
    [self tearDownGL];
}

- (void)readParentParams
{
    if(self.parent)
    {
        self.parentRotation = self.parent.parentRotation + self.parent.rotation;
        self.parentPosition = GLKVector2Make(self.parent.parentPosition.x + self.parent.position.x,
                                             self.parent.parentPosition.y + self.parent.position.y);
        self.parentScale = GLKVector2Make(self.parent.parentScale.x * self.parent.scale.x,
                                          self.parent.parentScale.y * self.parent.scale.y);
    }
}

//этот метод нужно вызывать всякий раз, когда поменялись параметры трансформации нода
- (void)prepareTransformation
{
    [self readParentParams];
    
    //===
    
    float aspect = fabsf(self.glView.bounds.size.width / self.glView.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_fovyRadians), aspect, _nearOffset, _farOffset);    
    self.effect.transform.projectionMatrix = projectionMatrix;
   
    GLKMatrix4 modelViewMatrix;

    /*
     Transformation order:
     1) rotation;
     2) scale;
     3) translation (change position).
     */
    modelViewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeRotation(self.rotation +self.parentRotation,
                                                                0, 0, 1),
                                         GLKMatrix4MakeScale(self.scale.x * self.parentScale.x,
                                                             self.scale.y * self.parentScale.y,
                                                             1)
                                         );
    modelViewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(self.position.x + self.parentPosition.x,
                                                                   self.position.y + self.parentPosition.y,
                                                                   _defaultZOffset), 
                                         modelViewMatrix);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)draw
{
    
    //TODO: to improve performance remove it from here and call everytime you change the params:
    [self prepareTransformation];
    
    [self.effect prepareToDraw];
 
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glBindVertexArrayOES(_vertexArray);   
    glDrawElements(GL_TRIANGLES, sizeof(vertexIndices)/sizeof(vertexIndices[0]), GL_UNSIGNED_BYTE, 0);
}

@end