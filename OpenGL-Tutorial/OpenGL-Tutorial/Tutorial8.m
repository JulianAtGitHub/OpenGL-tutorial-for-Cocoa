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
NSMutableData *uvData;
GLsizei nTriangle;

GLuint vertexBuffer;
GLuint normalBuffer;
GLuint uvBuffer;
GLuint texture;
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
    NSMutableArray *vertexDataTemp = [NSMutableArray array];
    NSMutableArray *normalDataTemp = [NSMutableArray array];
    NSMutableArray *uvDataTemp = [NSMutableArray array];
    NSMutableArray *triangleDataTemp = [NSMutableArray array];
    while (1) {

        char line[128];
        if (fscanf(file, "%s", line) == EOF) {
            break;
        }

        if (strcmp(line, "v") == 0) {
            kmVec3 v;
            fscanf(file, "%f %f %f\n", &v.x, &v.y, &v.z);
            [vertexDataTemp addObject:[NSValue valueWithBytes:&v objCType:@encode(kmVec3)]];
        }
        if (strcmp(line, "vn") == 0) {
            kmVec3 vn;
            fscanf(file, "%f %f %f\n", &vn.x, &vn.y, &vn.z);
            [normalDataTemp addObject:[NSValue valueWithBytes:&vn objCType:@encode(kmVec3)]];
        }
        if (strcmp(line, "vt") == 0) {
            kmVec2 vt;
            fscanf(file, "%f %f\n", &vt.x, &vt.y);
            [uvDataTemp addObject:[NSValue valueWithBytes:&vt objCType:@encode(kmVec2)]];
        }

        if (strcmp(line, "f") == 0) {
            unsigned int indexVertex[3], indexUV[3], indexNormal[3];
            int matches = fscanf(file, "%d/%d/%d %d/%d/%d %d/%d/%d\n", &indexVertex[0], &indexUV[0], &indexNormal[0], &indexVertex[1], &indexUV[1], &indexNormal[1], &indexVertex[2], &indexUV[2], &indexNormal[2] );
            if (matches != 9) {
                NSLog(@"File can't be read by our simple parser :( Try exporting with other options\n");
                return NO;
            }
            
            [triangleDataTemp addObject:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:indexVertex[0]-1], [NSNumber numberWithUnsignedInt:indexUV[0]-1], [NSNumber numberWithUnsignedInt:indexNormal[0]-1], nil]];
            
            [triangleDataTemp addObject:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:indexVertex[1]-1], [NSNumber numberWithUnsignedInt:indexUV[1]-1], [NSNumber numberWithUnsignedInt:indexNormal[1]-1], nil]];
            
            [triangleDataTemp addObject:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:indexVertex[2]-1], [NSNumber numberWithUnsignedInt:indexUV[2]-1], [NSNumber numberWithUnsignedInt:indexNormal[2]-1], nil]];
            
            nTriangle++;
        }
    }
    
    vertexData = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec3)];
    normalData = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec3)];
    uvData = [NSMutableData dataWithLength:nTriangle*3*sizeof(kmVec2)];
    kmVec3 *vertexArray = (kmVec3 *)[vertexData mutableBytes];
    kmVec3 *normalArray = (kmVec3 *)[normalData mutableBytes];
    kmVec2 *uvArray = (kmVec2 *)[uvData mutableBytes];
    
    for (unsigned int i = 0; i < nTriangle*3; ++i) {
        NSArray *indexData = [triangleDataTemp objectAtIndex:i];
        unsigned int indexVertex = [[indexData objectAtIndex:0] unsignedIntValue];
        unsigned int indexUV = [[indexData objectAtIndex:1] unsignedIntValue];
        unsigned int indexNormal = [[indexData objectAtIndex:2] unsignedIntValue];
        [[vertexDataTemp objectAtIndex:indexVertex] getValue:&vertexArray[i]];
        [[normalDataTemp objectAtIndex:indexNormal] getValue:&normalArray[i]];
        [[uvDataTemp objectAtIndex:indexUV] getValue:&uvArray[i]];
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
    
    GSTextureController *textureController = [GSTextureController sharedTextureController];
    texture = [textureController textureWithFileName:@"suzanne_texture.png" useMipmap:NO];
    
    // handle shaders
    GSShaderController *shaderController = [GSShaderController sharedShaderController];
    program = [shaderController programWithVertexShaderFile:@"tutorial8.vs" FragmentShaderFile:@"tutorial8.fs"];
    glUseProgram(program);
    
    GLint local_image0 = glGetUniformLocation(program, "image0");
    glActiveTexture(GL_TEXTURE0);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(local_image0, 0);
    glDisable(GL_TEXTURE_2D);
    
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
    
    GLint material_shininess = glGetUniformLocation(program, "material_shininess");
    glUniform1f(material_shininess, 50.0f);
    
    // create vertex attribute buffers
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, [vertexData length], [vertexData mutableBytes], GL_STATIC_DRAW);
    
    glGenBuffers(1, &normalBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, [normalData length], [normalData mutableBytes], GL_STATIC_DRAW);
    
    glGenBuffers(1, &uvBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, uvBuffer);
    glBufferData(GL_ARRAY_BUFFER, [uvData length], [uvData mutableBytes], GL_STATIC_DRAW);
    
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
    
    glBindBuffer(GL_ARRAY_BUFFER, uvBuffer);
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 0, (GLvoid *)0);
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glDisable(GL_TEXTURE_2D);
    
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
    glDeleteBuffers(1, &uvBuffer);
    glDeleteTextures(1, &texture);
    glDeleteVertexArrays(1, &vertexArrayObj);
    glDeleteProgram(program);
    
    [super clearGLContext];
}

@end

