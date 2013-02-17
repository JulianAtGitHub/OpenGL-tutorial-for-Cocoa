//
//  GSTextureController.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 17/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSTextureController.h"
#import "GSOpenGLInfoHelper.h"
#import <OpenGL/gl3.h>
#import <OpenGL/gl3ext.h>

unsigned long getNextPOT(unsigned long x)
{
    x = x - 1;
    x = x | (x >> 1);
    x = x | (x >> 2);
    x = x | (x >> 4);
    x = x | (x >> 8);
    x = x | (x >>16);
    return x + 1;
}

@implementation GSTextureController

+ (GSTextureController *)sharedTextureController
{
    static GSTextureController *instance = nil;
    
    if (instance == nil) {
        instance = [[GSTextureController alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        //GSOpenGLInfoHelper *openGLInfoHelp = [GSOpenGLInfoHelper sharedOpenGLInfoHelper];
        //_supportsNPOT = [openGLInfoHelp checkForGLExtension:@"GL_ARB_texture_non_power_of_two"];
        _supportsNPOT = YES;
    }
    
    return self;
}

- (GLuint)textureWithFileName:(NSString *)fileName
{
    NSString *fullPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath] == NO) {
        NSLog(@"%@ not exist", fullPath);
        return 0;
    }
    
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:fullPath];
    NSBitmapImageRep *image = [[NSBitmapImageRep alloc] initWithData:fileData];
    CGImageRef cgImage = [image CGImage];
    
    CGImageAlphaInfo info = CGImageGetAlphaInfo(cgImage);
    //support NPOT
    NSUInteger textureWidth, textureHeight;
    if( self.supportsNPOT == NO )
	{
		textureWidth = getNextPOT(CGImageGetWidth(cgImage));
		textureHeight = getNextPOT(CGImageGetHeight(cgImage));
	}
	else
	{
		textureWidth = CGImageGetWidth(cgImage);
		textureHeight = CGImageGetHeight(cgImage);
	}
    CGSize imageSize = CGSizeMake(CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    BOOL hasAlpha = ((info == kCGImageAlphaPremultipliedLast) || (info == kCGImageAlphaPremultipliedFirst) || (info == kCGImageAlphaLast) || (info == kCGImageAlphaFirst) ? YES : NO);
    
    if(colorSpace) {
		if( hasAlpha ) {
			info = kCGImageAlphaPremultipliedLast;
		} else {
			info = kCGImageAlphaNoneSkipLast;
		}
	} else {
		return 0;
	}
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    void *data = malloc(textureHeight * textureWidth * 4);
    CGContextRef context = CGBitmapContextCreate(data, textureWidth, textureHeight, 8, 4 * textureWidth, colorSpace, info | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextClearRect(context, CGRectMake(0, 0, textureWidth, textureHeight));
	CGContextTranslateCTM(context, 0, textureHeight - imageSize.height);
	CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage)), cgImage);
    
    //glPixelStorei(GL_UNPACK_ALIGNMENT,4);
    GLuint texObj;
    glGenTextures(1, &texObj);
    
    glActiveTexture(GL_TEXTURE0);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texObj);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)textureWidth, (GLsizei)textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glDisable(GL_TEXTURE_2D);
    
    CGContextRelease(context);
    free(data);
    
    return texObj;
}

@end
