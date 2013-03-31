//
//  Scene.h
//  MyEngine
//
//  Created by Максим Хацкевич on 29.05.12.
//  Copyright (c) 2012 max@nebitech.ru. All rights reserved.
//

/*
 
 Сцена — это холст, на котором отрисовываются все спрайты.
 
 Функции сцены:
 - инициализирует контекст;
 - управляет отрисовкой, метод drawAll вызывает перерисовку фона
   и всех спрайтов на сцене.
 
 */

#import "Node.h"
#import "Sprite.h"

typedef struct {
    float r; //red
    float g; //green
    float b; //blue
    float a; //alpha
} Color;

@interface Scene : Node<GLKViewDelegate>

@property Color bgColor; //backgroun color 

+ (id)createWithGLView: (GLKView *)targetView;

- (Sprite *)spriteWithTextureFile: (NSString *)pngFileName;

- (void)setupGL;
- (void)draw;

@end
