//
//  Sprite.h
//  MyEngine
//
//  Created by Максим Хацкевич on 29.05.12.
//  Copyright (c) 2012 max@nebitech.ru. All rights reserved.
//

/*
 
 Спрайт - класс для отображения произвольной картинки (текстуры)
 поверх сцены. У него жестко заданы размеры 2х2 (в условиях
 задачи атрибутов для размеров не было, и я не стал на это
 заморачиваться - добавить не проблема, можно в ручную ставить,
 можна задавать автоматом по размерам текстуры в пикселях).
 Класс при отрисовке учитывает параметры position, rotation,
 scale, layer (zOrder) — все относительно родителя (родителем
 может быть любой Node - сцена или другой спрайт).
 
 */

#import "Node.h"
#import <GLKit/GLKit.h>

typedef struct {
    float position[3];
    float color[4];
    float texCoord[2];
} Vertex;

@interface Sprite : Node
{
    GLuint _vertexBuffer;
    GLuint _indexBuffer;   
    GLuint _vertexArray;
}

@property(readonly) float fovyRadians;
@property(readonly) float nearOffset;
@property(readonly) float farOffset;
@property(readonly) float defaultZOffset; //default global offset of sprites by z-axis
@property(readonly) float layerZOffset; //global layer offset by z-axis depend on z-order

@property (nonatomic, retain) GLKBaseEffect *effect;

+ (id)createWithGLView: (GLKView *)targetView andTextureFile: (NSString *)pngFileName;

- (void)setupGL;
- (void)prepareTransformation;
- (void)draw;

@end