//
//  Tutorial3.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 30/1/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <OpenGL/gl3.h>
#import "kazmath/kazmath.h"
#import "GSOpenGLView.h"
#import "GSShaderController.h"

// globle value

static const kmVec3 vertexArrayData[] = {
    {-1.0f, -1.0f, 0.0f},
    {1.0f, -1.0f, 0.0f},
    {0.0f,  1.0f, 0.0f},
};

GLuint vertexBuffer;
GLuint program;
GLuint vertexArrayObj;

// class Tutorial3
@interface Tutorial3 : NSObject <GSOpenGLViewDelegate>

@end

@implementation Tutorial3

- (BOOL)prepareRenderData
{
    kmMat4 projection; 
    kmMat4 view;
    kmMat4 model;
    kmMat4 MVP; 
    
    kmVec3 eye = {4.0, 3.0, 3.0};
    kmVec3 center = {0.0, 0.0, 0.0};
    kmVec3 up = {0.0, 1.0, 0.0};
    
    kmMat4PerspectiveProjection(&projection, 45.0f, 4.0f/3.0f, 0.1f, 100.0f);
    kmMat4LookAt(&view, &eye, &center, &up);
    kmMat4Identity(&model);
    
    kmMat4Multiply(&MVP, &projection, &view);
    kmMat4Multiply(&MVP, &MVP, &model);
    
    GSShaderController *shaderController = [GSShaderController sharedShaderController];
    program = [shaderController programWithVertexShaderFile:@"tutorial3.vs" FragmentShaderFile:@"tutorial3.fs"];
    glUseProgram(program);
    GLint local_MVP = glGetUniformLocation(program, "MVP");
    glUniformMatrix4fv(local_MVP, 1, GL_FALSE, (GLfloat *)&MVP);
    
    glGenVertexArrays(1, &vertexArrayObj);
    glBindVertexArray(vertexArrayObj);
    
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

- (void)update:(NSTimeInterval)timeInterval
{
    
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
    
    Set_OpenGLViewDelegate(Tutorial3);
}

- (void)clearGLContext
{
    glDeleteBuffers(1, &vertexBuffer);
    glDeleteVertexArrays(1, &vertexArrayObj);
    glDeleteProgram(program);
    
    [super clearGLContext];
}

@end
