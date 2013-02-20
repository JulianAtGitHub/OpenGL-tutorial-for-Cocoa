//
//  Tutorial7.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 20/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <OpenGL/gl3.h>
#import "kazmath/kazmath.h"
#import "GSOpenGLView.h"
#import "GSShaderController.h"
#import "GSTextureController.h"
#import "GSInputController.h"

// globle value

NSMutableData *vertexData;
NSMutableData *uvData;
GLsizei nTriangle;

kmVec3 eye = {4.0, 3.0, 3.0};
kmVec3 center = {0.0, 0.0, 0.0};
kmVec3 up = {0.0, 1.0, 0.0};

GLuint vertexBuffer;
//GLuint colorBuffer;
GLuint uvBuffer;
GLuint texture;
GLuint program;
GLuint vertexArrayObj;

// class Tutorial4
@interface Tutorial7 : NSObject <GSOpenGLViewDelegate, GSInputDelegate>

@end

@implementation Tutorial7

- (BOOL)loadModelFromFile:(NSString *)fileName
{
    NSString *fullPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath] == NO) {
        NSLog(@"%@ not exist", fullPath);
        return NO;
    }
    
    FILE *file = fopen([fullPath UTF8String], "r");
    if( file == NULL ){
        NSLog(@"%@ read faild", fullPath);
        return NO;
    }
    
    nTriangle = 0;
    while (1) {
        char line[128];
        if (fscanf(file, "%s", line) == EOF) {
            break;
        }
        
        if (strcmp(line, "f") == 0) {
            nTriangle++;
        }
    }
    fclose(file);
    
    
    vertexData = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec3)];
    uvData = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec2)];
    kmVec3 *vertexArray = (kmVec3 *)[vertexData mutableBytes];
    kmVec2 *uvArray = (kmVec2 *)[uvData mutableBytes];
    NSUInteger vertexIndex = 0;
    NSUInteger uvIndex = 0;
    
    NSMutableData *vertexDataTemp = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec3)];
    NSMutableData *uvDataTemp = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec2)];
    kmVec3 *vertexArrayTemp = (kmVec3 *)[vertexDataTemp mutableBytes];
    kmVec2 *uvArrayTemp = (kmVec2 *)[uvDataTemp mutableBytes];
    NSUInteger vertexTempIndex = 0;
    NSUInteger uvTempIndex = 0;
    
    file = fopen([fullPath UTF8String], "r");
    while (1) {
        
        char line[128];
        if (fscanf(file, "%s", line) == EOF) {
            break;
        }
        
        if (strcmp(line, "v") == 0) {
            fscanf(file, "%f %f %f\n", &vertexArrayTemp[vertexTempIndex].x, &vertexArrayTemp[vertexTempIndex].y, &vertexArrayTemp[vertexTempIndex].z);
            vertexTempIndex++;
        }
        if (strcmp(line, "vt") == 0) {
            fscanf(file, "%f %f\n", &uvArrayTemp[uvTempIndex].x, &uvArrayTemp[uvTempIndex].y);
            uvTempIndex++;
        }
        if (strcmp(line, "vn") == 0) {
            // skip normal
        }
        
        if (strcmp(line, "f") == 0) {
            unsigned int indexVertex[3], indexUV[3], indexNormap[3];
            int matches = fscanf(file, "%d/%d/%d %d/%d/%d %d/%d/%d\n", &indexVertex[0], &indexUV[0], &indexNormap[0], &indexVertex[1], &indexUV[1], &indexNormap[1], &indexVertex[2], &indexUV[2], &indexNormap[2] );
            if (matches != 9) {
                NSLog(@"File can't be read by our simple parser :( Try exporting with other options\n");
                return NO;
            }
            
            memcpy(&vertexArray[vertexIndex], &vertexArrayTemp[indexVertex[0]-1], sizeof(kmVec3)); vertexIndex++;
            memcpy(&vertexArray[vertexIndex], &vertexArrayTemp[indexVertex[1]-1], sizeof(kmVec3)); vertexIndex++;
            memcpy(&vertexArray[vertexIndex], &vertexArrayTemp[indexVertex[2]-1], sizeof(kmVec3)); vertexIndex++;
            memcpy(&uvArray[uvIndex], &uvArrayTemp[indexUV[0]-1], sizeof(kmVec2)); uvIndex++;
            memcpy(&uvArray[uvIndex], &uvArrayTemp[indexUV[1]-1], sizeof(kmVec2)); uvIndex++;
            memcpy(&uvArray[uvIndex], &uvArrayTemp[indexUV[2]-1], sizeof(kmVec2)); uvIndex++;
        }
    }
    
    fclose(file);
    
    return YES;
}

- (BOOL)prepareRenderData
{
    [[GSInputController sharedInputController] addKeyEventDelegate:self];
    
    [self loadModelFromFile:@"cube.obj"];
    
    GSTextureController *textureController = [GSTextureController sharedTextureController];
    texture = [textureController textureWithFileName:@"cube_texture.png" useMipmap:NO];
    
    // handle shaders
    GSShaderController *shaderController = [GSShaderController sharedShaderController];
    program = [shaderController programWithVertexShaderFile:@"tutorial7.vs" FragmentShaderFile:@"tutorial7.fs"];
    glUseProgram(program);
    
    GLint local_image0 = glGetUniformLocation(program, "image0");
    glActiveTexture(GL_TEXTURE0);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(local_image0, 0);
    glDisable(GL_TEXTURE_2D);
    
    // create vertex attribute buffers
    kmVec3 *vertexArray = (kmVec3 *)[vertexData mutableBytes];
    kmVec2 *uvArray = (kmVec2 *)[uvData mutableBytes];
    for (int i = 0; i < nTriangle*3; ++i) {
        NSLog(@"x:%f y:%f z:%f u:%f v%f", vertexArray[i].x, vertexArray[i].y,vertexArray[i].z, uvArray[i].x, uvArray[i].y);
    }
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [vertexData length], [vertexData mutableBytes], GL_STATIC_DRAW);
    
    glGenBuffers(1, &uvBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, uvBuffer);
    glBufferData(GL_ARRAY_BUFFER, [uvData length], [uvData mutableBytes], GL_STATIC_DRAW);
    
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

- (void)update:(NSTimeInterval)timeInterval
{
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
    
    glDrawArrays(GL_TRIANGLES, 0, nTriangle*3);
    
    glBindVertexArray(0);
}

@end

@implementation GSOpenGLView(Tutorial)

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    
    glEnable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    Set_OpenGLViewDelegate(Tutorial7);
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
