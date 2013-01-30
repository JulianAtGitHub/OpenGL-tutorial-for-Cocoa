//
//  Tutorial1.m
//  OpenGL-Tutorial
//
//  Created by wei.zhu on 1/23/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSOpenGLView.h"
#import <OpenGL/gl3.h>

@interface Tutorial1 : NSObject <GSOpenGLViewDelegate> {

}

@end

@implementation Tutorial1

- (BOOL)prepareRenderData
{
    return YES;
}

- (void)render;
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

@end

@implementation GSOpenGLView(Tutorial)

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glClearColor(0.67, 0.0, 0.5, 1.0);
    
    Set_OpenGLViewDelegate(Tutorial1);
}

@end

