//
//  GSOpenGLView.m
//  OpenGL-Tutorial
//
//  Created by wei.zhu on 1/23/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSOpenGLView.h"
#import <OpenGL/gl3.h>

@implementation GSOpenGLView

//- (void)prepareOpenGL
//{
//    glClearColor(0.67, 0.0, 0.5, 1.0);
//    
//    if ([self.delegate respondsToSelector:@selector(prepareRenderData)]) {
//        [self.delegate prepareRenderData];
//    }
//}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [[self openGLContext] makeCurrentContext];
    
    if ([self.delegate respondsToSelector:@selector(render)]) {
        [self.delegate render];
    }
    
    [[self openGLContext] flushBuffer];
}

- (void)update  // moved or resized
{
    [super update];

    [[self openGLContext] makeCurrentContext];
    [[self openGLContext] update];
    
    NSRect rect = [self bounds];
    glViewport(0, 0, (GLint) rect.size.width, (GLint) rect.size.height);
}

- (void)reshape
{
    [super reshape];
    
    [[self openGLContext] makeCurrentContext];
    [[self openGLContext] update];
    
    NSRect rect = [self bounds];
    glViewport(0, 0, rect.size.width, rect.size.height);
}

@end
