//
//  Tutorial2.m
//  OpenGL3D
//
//  Created by wei.zhu on 1/24/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <OpenGL/gl3.h>
#import "kazmath/kazmath.h"
#import "GSOpenGLView.h"
#import "GSOpenGLShaderController.h"

// globle value
GLuint vertexArrayObj;
static const kmVec3 vertexArrayData[] = {
    {-1.0f, -1.0f, 0.0f},
    {1.0f, -1.0f, 0.0f},
    {0.0f,  1.0f, 0.0f},
};
GLuint program;

// class Tutorial2
@interface Tutorial2 : NSObject <GSOpenGLViewDelegate>

@end

@implementation Tutorial2

- (BOOL)prepareRenderData
{
    GSOpenGLShaderController *shaderController = [GSOpenGLShaderController sharedOpenGLShaderController];
    program = [shaderController programWithVertexShaderFile:@"tutorial2.vs" FragmentShaderFile:@"tutorial2.fs"];
    
    glGenVertexArrays(1, &vertexArrayObj);
    glBindVertexArray(vertexArrayObj);
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexArrayData), vertexArrayData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    
    glUseProgram(program);
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    return YES;
}

- (void)render;
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArray(vertexArrayObj);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glBindVertexArray(0);
}

@end

@implementation GSOpenGLView(Tutorial)

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    Set_OpenGLViewDelegate(Tutorial2);
}

@end
