//
//  Tutorial6.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 19/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <OpenGL/gl3.h>
#import "kazmath/kazmath.h"
#import "GSOpenGLView.h"
#import "GSShaderController.h"
#import "GSTextureController.h"
#import "GSInputController.h"

// globle value

static const kmVec3 vertexBufferData[] = {
    {-1.0f,-1.0f,-1.0f},
    {-1.0f,-1.0f, 1.0f},
    {-1.0f, 1.0f, 1.0f},
    {1.0f, 1.0f,-1.0f},
    {-1.0f,-1.0f,-1.0f},
    {-1.0f, 1.0f,-1.0f},
    {1.0f,-1.0f, 1.0f},
    {-1.0f,-1.0f,-1.0f},
    {1.0f,-1.0f,-1.0f},
    {1.0f, 1.0f,-1.0f},
    {1.0f,-1.0f,-1.0f},
    {-1.0f,-1.0f,-1.0f},
    {-1.0f,-1.0f,-1.0f},
    {-1.0f, 1.0f, 1.0f},
    {-1.0f, 1.0f,-1.0f},
    {1.0f,-1.0f, 1.0f},
    {-1.0f,-1.0f, 1.0f},
    {-1.0f,-1.0f,-1.0f},
    {-1.0f, 1.0f, 1.0f},
    {-1.0f,-1.0f, 1.0f},
    {1.0f,-1.0f, 1.0f},
    {1.0f, 1.0f, 1.0f},
    {1.0f,-1.0f,-1.0f},
    {1.0f, 1.0f,-1.0f},
    {1.0f,-1.0f,-1.0f},
    {1.0f, 1.0f, 1.0f},
    {1.0f,-1.0f, 1.0f},
    {1.0f, 1.0f, 1.0f},
    {1.0f, 1.0f,-1.0f},
    {-1.0f, 1.0f,-1.0f},
    {1.0f, 1.0f, 1.0f},
    {-1.0f, 1.0f,-1.0f},
    {-1.0f, 1.0f, 1.0f},
    {1.0f, 1.0f, 1.0f},
    {-1.0f, 1.0f, 1.0f},
    {1.0f,-1.0f, 1.0f}
};

//static const kmVec3 colorBufferData[] = {
//    {0.583f,  0.771f,  0.014f},
//    {0.609f,  0.115f,  0.436f},
//    {0.327f,  0.483f,  0.844f},
//    {0.822f,  0.569f,  0.201f},
//    {0.435f,  0.602f,  0.223f},
//    {0.310f,  0.747f,  0.185f},
//    {0.597f,  0.770f,  0.761f},
//    {0.559f,  0.436f,  0.730f},
//    {0.359f,  0.583f,  0.152f},
//    {0.483f,  0.596f,  0.789f},
//    {0.559f,  0.861f,  0.639f},
//    {0.195f,  0.548f,  0.859f},
//    {0.014f,  0.184f,  0.576f},
//    {0.771f,  0.328f,  0.970f},
//    {0.406f,  0.615f,  0.116f},
//    {0.676f,  0.977f,  0.133f},
//    {0.971f,  0.572f,  0.833f},
//    {0.140f,  0.616f,  0.489f},
//    {0.997f,  0.513f,  0.064f},
//    {0.945f,  0.719f,  0.592f},
//    {0.543f,  0.021f,  0.978f},
//    {0.279f,  0.317f,  0.505f},
//    {0.167f,  0.620f,  0.077f},
//    {0.347f,  0.857f,  0.137f},
//    {0.055f,  0.953f,  0.042f},
//    {0.714f,  0.505f,  0.345f},
//    {0.783f,  0.290f,  0.734f},
//    {0.722f,  0.645f,  0.174f},
//    {0.302f,  0.455f,  0.848f},
//    {0.225f,  0.587f,  0.040f},
//    {0.517f,  0.713f,  0.338f},
//    {0.053f,  0.959f,  0.120f},
//    {0.393f,  0.621f,  0.362f},
//    {0.673f,  0.211f,  0.457f},
//    {0.820f,  0.883f,  0.371f},
//    {0.982f,  0.099f,  0.879f}
//};

static const kmVec2 uvBufferData[] = {
    {0.000059f, 0.000004f},
    {0.000103f, 0.336048f},
    {0.335973f, 0.335903f},
    {1.000023f, 0.000013f},
    {0.667979f, 0.335851f},
    {0.999958f, 0.336064f},
    {0.667979f, 0.335851f},
    {0.336024f, 0.671877f},
    {0.667969f, 0.671889f},
    {1.000023f, 0.000013f},
    {0.668104f, 0.000013f},
    {0.667979f, 0.335851f},
    {0.000059f, 0.000004f},
    {0.335973f, 0.335903f},
    {0.336098f, 0.000071f},
    {0.667979f, 0.335851f},
    {0.335973f, 0.335903f},
    {0.336024f, 0.671877f},
    {1.000004f, 0.671847f},
    {0.999958f, 0.336064f},
    {0.667979f, 0.335851f},
    {0.668104f, 0.000013f},
    {0.335973f, 0.335903f},
    {0.667979f, 0.335851f},
    {0.335973f, 0.335903f},
    {0.668104f, 0.000013f},
    {0.336098f, 0.000071f},
    {0.000103f, 0.336048f},
    {0.000004f, 0.671870f},
    {0.336024f, 0.671877f},
    {0.000103f, 0.336048f},
    {0.336024f, 0.671877f},
    {0.335973f, 0.335903f},
    {0.667969f, 0.671889f},
    {1.000004f, 0.671847f},
    {0.667979f, 0.335851f}
};

float moveSpeed = 3.0f;
float rotateSpeed = 0.006f;
double thetaX = 0.0;
double thetaY = 0.0;
kmVec3 eye = {0.0, 0.0, 6.0};
kmVec3 center = {0.0, 0.0, 0.0};
kmVec3 up = {0.0, 1.0, 0.0};


GLuint vertexBuffer;
//GLuint colorBuffer;
GLuint uvBuffer;
GLuint texture;
GLuint program;
GLuint vertexArrayObj;

// class Tutorial4
@interface Tutorial6 : NSObject <GSOpenGLViewDelegate, GSInputDelegate>

@end

@implementation Tutorial6

- (BOOL)prepareRenderData
{
    [[GSInputController sharedInputController] addKeyEventDelegate:self];
    
    GSTextureController *textureController = [GSTextureController sharedTextureController];
    texture = [textureController textureWithFileName:@"uvtemplate.png" useMipmap:YES];
    
    // handle shaders
    GSShaderController *shaderController = [GSShaderController sharedShaderController];
    program = [shaderController programWithVertexShaderFile:@"tutorial6.vs" FragmentShaderFile:@"tutorial6.fs"];
    
    glUseProgram(program);
    
    GLint local_image0 = glGetUniformLocation(program, "image0");
    glActiveTexture(GL_TEXTURE0);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(local_image0, 0);
    glDisable(GL_TEXTURE_2D);
    
    // create vertex attribute buffers
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexBufferData), vertexBufferData, GL_STATIC_DRAW);
    
    glGenBuffers(1, &uvBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, uvBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(uvBufferData), uvBufferData, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // create vertex array for shader attributes
    glGenVertexArrays(1, &vertexArrayObj);
    glBindVertexArray(vertexArrayObj);
    
    glUseProgram(program);
    
    glActiveTexture(GL_TEXTURE0);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    
    glBindBuffer(GL_ARRAY_BUFFER, uvBuffer);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glDisable(GL_TEXTURE_2D);
    
    return YES;
}

- (void)mouseLeftDragWithX:(CGFloat)x andY:(CGFloat)y
{
    if (y == 0.0) {
        return;
    }
    
    kmVec3 lookAt;
    kmVec3Subtract(&lookAt, &center, &eye);
    kmScalar distance = kmVec3Length(&lookAt);
    
    thetaX += -x * rotateSpeed;
    thetaY += y * rotateSpeed;
    
    if (thetaX < -M_PI_4) {
        thetaX = -M_PI_4;
    }
    
    if (thetaX > M_PI_4) {
        thetaX = M_PI_4;
    }
    
    if (thetaY < -M_PI_4) {
        thetaY = -M_PI_4;
    }
    
    if (thetaY > M_PI_4) {
        thetaY = M_PI_4;
    }

    float deltaX = distance * sin(thetaX);
    float deltaY = distance * sin(thetaY);
    float deltaZ = sqrtf(kmSQR(distance) - kmSQR(deltaX) - kmSQR(deltaY));
    center.x = eye.x - deltaX;
    center.y = eye.y - deltaY;
    center.z = eye.z - deltaZ;
}

- (void)update:(NSTimeInterval)timeInterval
{
    GSInputController *inputController = [GSInputController sharedInputController];
    if ([inputController keyIsPressed:NSLeftArrowFunctionKey]) {
        float delta = moveSpeed * timeInterval;
        eye.x -= delta;
        center.x -= delta;
    } else if ([inputController keyIsPressed:NSRightArrowFunctionKey]) {
        float delta = moveSpeed * timeInterval;
        eye.x += delta;
        center.x += delta;
    } else if ([inputController keyIsPressed:NSUpArrowFunctionKey]) {
        float delta = moveSpeed * timeInterval;
        eye.z -= delta;
        center.z -= delta;
    } else if ([inputController keyIsPressed:NSDownArrowFunctionKey]) {
        float delta = moveSpeed * timeInterval;
        eye.z += delta;
        center.z += delta;
    }
    
    // matrix with model, view, projection
    kmMat4 projection;
    kmMat4 view;
    kmMat4 model;
    kmMat4 MVP;
    
    kmMat4PerspectiveProjection(&projection, 45.0f, 4.0f/3.0f, 0.1f, 100.0f);
    kmMat4LookAt(&view, &eye, &center, &up);
    kmMat4Identity(&model);
    
    kmMat4Multiply(&MVP, &projection, &view);
    kmMat4Multiply(&MVP, &MVP, &model);
    
    glUseProgram(program);
    
    GLint local_MVP = glGetUniformLocation(program, "MVP");
    glUniformMatrix4fv(local_MVP, 1, GL_FALSE, (GLfloat *)&MVP);
}

- (void)render;
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArray(vertexArrayObj);
    
    glDrawArrays(GL_TRIANGLES, 0, 12*3);
    
    glBindVertexArray(0);
}

@end

@implementation GSOpenGLView(Tutorial)

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    Set_OpenGLViewDelegate(Tutorial6);
}

- (void)clearGLContext
{
    glDeleteBuffers(1, &vertexBuffer);
    //glDeleteBuffers(1, &colorBuffer);
    glDeleteBuffers(1, &uvBuffer);
    glDeleteTextures(1, &texture);
    glDeleteVertexArrays(1, &vertexArrayObj);
    glDeleteProgram(program);
    
    [super clearGLContext];
}

@end
