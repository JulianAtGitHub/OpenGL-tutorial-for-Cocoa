//
//  Tutorial4.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 31/1/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <OpenGL/gl3.h>
#import "kazmath/kazmath.h"
#import "GSOpenGLView.h"
#import "GSShaderController.h"

// globle value
static const kmVec3 vertexBufferData[] = {
    {-1.0f, -1.0f, -1.0f},
    {-1.0f, -1.0f,  1.0f},
    {-1.0f,  1.0f,  1.0f},
    {-1.0f,  1.0f, -1.0f},
    { 1.0f, -1.0f, -1.0f},
    { 1.0f, -1.0f,  1.0f},
    { 1.0f,  1.0f,  1.0f},
    { 1.0f,  1.0f, -1.0f},
};
static const kmVec3 colorBufferData[] = {
    {0.583f, 0.771f, 0.014f},
    {0.609f, 0.115f, 0.436f},
    {0.327f, 0.483f, 0.844f},
    {0.310f, 0.747f, 0.185f},
    {0.359f, 0.583f, 0.152f},
    {0.597f, 0.770f, 0.761f},
    {0.673f, 0.211f, 0.457f},
    {0.822f, 0.569f, 0.201f},
};
static const GLubyte indexBufferData[] = {
    0,3,4,7,
    5,6,
    1,2,
    0,3,
    3,2,7,6,
    1,0,5,4,
};
GLuint vertexBuffer;
GLuint colorBuffer;
GLuint indexBuffer;
GLuint program;
GLuint vertexArrayObj;

// class Tutorial4
@interface Tutorial4 : NSObject <GSOpenGLViewDelegate>

@end

@implementation Tutorial4

- (BOOL)prepareRenderData
{
    // matrix with model, view, projection
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
    
    // handle shaders
    GSShaderController *shaderController = [GSShaderController sharedShaderController];
    program = [shaderController programWithVertexShaderFile:@"tutorial4.vs" FragmentShaderFile:@"tutorial4.fs"];
    glUseProgram(program);
    GLint local_MVP = glGetUniformLocation(program, "MVP");
    glUniformMatrix4fv(local_MVP, 1, GL_FALSE, (GLfloat *)&MVP);
    
    // create vertex attribute buffers
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexBufferData), vertexBufferData, GL_STATIC_DRAW);
    
    glGenBuffers(1, &colorBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(colorBufferData), colorBufferData, GL_STATIC_DRAW);
    
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indexBufferData), indexBufferData, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // create vertex array for shader attributes
    glGenVertexArrays(1, &vertexArrayObj);
    glBindVertexArray(vertexArrayObj);
    
    glUseProgram(program);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    
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

    glDrawElements(GL_TRIANGLE_STRIP, 18, GL_UNSIGNED_BYTE, (GLvoid *)0);
    
    glBindVertexArray(0);
}

@end

@implementation GSOpenGLView(Tutorial)

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    Set_OpenGLViewDelegate(Tutorial4);
}

- (void)clearGLContext
{
    glDeleteBuffers(1, &vertexBuffer);
    glDeleteBuffers(1, &colorBuffer);
    glDeleteBuffers(1, &indexBuffer);
    glDeleteVertexArrays(1, &vertexArrayObj);
    glDeleteProgram(program);
    
    [super clearGLContext];
}

@end
