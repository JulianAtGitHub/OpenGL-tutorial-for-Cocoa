//
//  Tutorial8.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 23/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <OpenGL/gl3.h>
#import "kazmath/kazmath.h"
#import "GSOpenGLView.h"
#import "GSShaderController.h"
#import "GSTextureController.h"
#import "GSCameraController.h"

// globle value

NSMutableData *vertexData;
NSMutableData *normalData;
GLsizei nTriangle;

GLuint vertexBuffer;
GLuint normalBuffer;
GLuint program;
GLuint vertexArrayObj;

// class Tutorial8
@interface Tutorial8 : NSObject <GSOpenGLViewDelegate> {
    GSCameraController *_camera;
}

@end

@implementation Tutorial8

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
    normalData = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec3)];
    kmVec3 *vertexArray = (kmVec3 *)[vertexData mutableBytes];
    kmVec3 *normalArray = (kmVec3 *)[normalData mutableBytes];
    NSUInteger vertexIndex = 0;
    NSUInteger normalIndex = 0;
    
    NSMutableData *vertexDataTemp = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec3)];
    NSMutableData *normalDataTemp = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec3)];
    kmVec3 *vertexArrayTemp = (kmVec3 *)[vertexDataTemp mutableBytes];
    kmVec3 *normalArrayTemp = (kmVec3 *)[normalDataTemp mutableBytes];
    NSUInteger vertexTempIndex = 0;
    NSUInteger normalTempIndex = 0;
    
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
        if (strcmp(line, "vn") == 0) {
            fscanf(file, "%f %f %f\n", &normalArrayTemp[normalTempIndex].x, &normalArrayTemp[normalTempIndex].y, &normalArrayTemp[normalTempIndex].z);
            normalTempIndex++;
        }
        if (strcmp(line, "vt") == 0) {
            // skip texture coord
        }
        
        if (strcmp(line, "f") == 0) {
            unsigned int indexVertex[3], indexUV[3], indexNormal[3];
            int matches = fscanf(file, "%d/%d/%d %d/%d/%d %d/%d/%d\n", &indexVertex[0], &indexUV[0], &indexNormal[0], &indexVertex[1], &indexUV[1], &indexNormal[1], &indexVertex[2], &indexUV[2], &indexNormal[2] );
            if (matches != 9) {
                NSLog(@"File can't be read by our simple parser :( Try exporting with other options\n");
                return NO;
            }
            
            memcpy(&vertexArray[vertexIndex], &vertexArrayTemp[indexVertex[0]-1], sizeof(kmVec3)); vertexIndex++;
            memcpy(&vertexArray[vertexIndex], &vertexArrayTemp[indexVertex[1]-1], sizeof(kmVec3)); vertexIndex++;
            memcpy(&vertexArray[vertexIndex], &vertexArrayTemp[indexVertex[2]-1], sizeof(kmVec3)); vertexIndex++;
            memcpy(&normalArray[normalIndex], &normalArrayTemp[indexNormal[0]-1], sizeof(kmVec3)); normalIndex++;
            memcpy(&normalArray[normalIndex], &normalArrayTemp[indexNormal[1]-1], sizeof(kmVec3)); normalIndex++;
            memcpy(&normalArray[normalIndex], &normalArrayTemp[indexNormal[2]-1], sizeof(kmVec3)); normalIndex++;
        }
    }
    
    fclose(file);
    
    return YES;
}

- (BOOL)prepareRenderData
{
    kmVec3 eye = {4.0, 3.0, 3.0};
    kmVec3 center = {0.0, 0.0, 0.0};
    kmVec3 up = {0.0, 1.0, 0.0};
    _camera = [[GSCameraController alloc] initWithEye:eye Center:center Up:up];
    
    [self loadModelFromFile:@"suzanne.obj"];
    
    // handle shaders
    GSShaderController *shaderController = [GSShaderController sharedShaderController];
    program = [shaderController programWithVertexShaderFile:@"tutorial8.vs" FragmentShaderFile:@"tutorial8.fs"];
    glUseProgram(program);
    
    GLint light_direction = glGetUniformLocation(program, "light_direction");
    glUniform3f(light_direction, 0.0f, 1.0f, 1.0f);
    
    GLint light_color = glGetUniformLocation(program, "light_color");
    glUniform3f(light_color, 1.0f, 1.0f, 1.0f);
    
    GLint light_ambient_power = glGetUniformLocation(program, "light_ambient_power");
    glUniform1f(light_ambient_power, 0.1f);
    
    GLint light_diffuse_power = glGetUniformLocation(program, "light_diffuse_power");
    glUniform1f(light_diffuse_power, 0.7f);
    
    GLint light_specular_power = glGetUniformLocation(program, "light_specular_power");
    glUniform1f(light_specular_power, 0.2f);
    
    GLint material_color = glGetUniformLocation(program, "material_color");
    glUniform3f(material_color, 0.66f, 0.0f, 0.8f);
    
    GLint material_shininess = glGetUniformLocation(program, "material_shininess");
    glUniform1f(material_shininess, 50.0f);
    
    // create vertex attribute buffers
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [vertexData length], [vertexData mutableBytes], GL_STATIC_DRAW);
    
    glGenBuffers(1, &normalBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, [normalData length], [normalData mutableBytes], GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // create vertex array for shader attributes
    glGenVertexArrays(1, &vertexArrayObj);
    glBindVertexArray(vertexArrayObj);
    
    glUseProgram(program);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    
    return YES;
}

- (void)update:(NSTimeInterval)timeInterval
{
    // matrix with model, view, projection
    kmMat4 projection = [_camera perspectiveMatrix];
    kmMat4 view = [_camera viewMatrix];
    kmMat4 model;
    kmMat4Identity(&model);
    
    kmMat4 MVP;
    kmMat4Multiply(&MVP, &projection, &view);
    kmMat4Multiply(&MVP, &MVP, &model);
    
    glUseProgram(program);
    
    GLint local_MVP = glGetUniformLocation(program, "MVP");
    glUniformMatrix4fv(local_MVP, 1, GL_FALSE, (GLfloat *)&MVP);
    
    kmVec3 eye = _camera.eye;
    GLint eye_position = glGetUniformLocation(program, "eye_position");
    glUniform3f(eye_position, eye.x, eye.y, eye.z);
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
    
    Set_OpenGLViewDelegate(Tutorial8);
}

- (void)clearGLContext
{
    glDeleteBuffers(1, &vertexBuffer);
    glDeleteBuffers(1, &normalBuffer);
    glDeleteVertexArrays(1, &vertexArrayObj);
    glDeleteProgram(program);
    
    [super clearGLContext];
}

@end

