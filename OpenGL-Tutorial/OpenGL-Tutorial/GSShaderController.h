//
//  GSOpenGLShaderController.h
//  OpenGL-Tutorial
//
//  Created by wei.zhu on 1/28/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSShaderController : NSObject

+ (GSShaderController *)sharedShaderController;

- (GLuint)programWithVertexShader:(NSString *)vsContent FragmentShader:(NSString *)fsContent;
- (GLuint)programWithVertexShaderFile:(NSString *)vsfilePath FragmentShaderFile:(NSString *)fsFilePath;

@end
