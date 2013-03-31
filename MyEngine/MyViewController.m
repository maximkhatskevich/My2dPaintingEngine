//
//  MyViewController.m
//  MyEngine
//
//  Created by Максим Хацкевич on 28.05.12.
//  Copyright (c) 2012 max@nebitech.ru. All rights reserved.
//

#import "MyViewController.h"
#import "Scene.h"
#import "Sprite.h"

Scene *myScene;
Sprite *email;
Sprite *tile;
Sprite *ball;

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    myScene = [Scene createWithGLView:(GLKView *)self.view];
    
    tile = [myScene spriteWithTextureFile:@"tile_floor"];
    [myScene addChild:tile onLayer:1];

    email = [myScene spriteWithTextureFile:@"e-mail"];
    [myScene addChild:email onLayer:1];
    
    ball = [myScene spriteWithTextureFile:@"ball"];
    [email addChild:ball onLayer:1];
    
    //=== тестим работоспособность параметров:
    
    email.rotation = 35;
    tile.rotation = 75;
//    ball.rotation = 75;
    
//    Vector2 buf;
//    buf.x = 40;
//    buf.y = 40;
    email.scale = GLKVector2Make(1.5, 0.5);
    email.position = GLKVector2Make(1, -1);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
