//
//  GSOpenGLInfoHelper.m
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 17/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSOpenGLInfoHelper.h"
#import <OpenGL/gl3.h>
#import <OpenGL/gl3ext.h>

static char *glExtensions = nil;

@implementation GSOpenGLInfoHelper

+ (GSOpenGLInfoHelper *)sharedOpenGLInfoHelper
{
    static GSOpenGLInfoHelper *instance = nil;
    
    if (instance == nil) {
        instance = [[GSOpenGLInfoHelper alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"GL_VENDOR:   %s", glGetString(GL_VENDOR) );
		NSLog(@"GL_RENDERER: %s", glGetString ( GL_RENDERER   ) );
		NSLog(@"GL_VERSION:  %s", glGetString ( GL_VERSION    ) );
		glExtensions = (char*) glGetString(GL_EXTENSIONS);
    }
    
    return self;
}

- (BOOL) checkForGLExtension:(NSString *)searchName
{
	// For best results, extensionsNames should be stored in your renderer so that it does not
	// need to be recreated on each invocation.
    NSString *extensionsString = [NSString stringWithCString:glExtensions encoding: NSASCIIStringEncoding];
    NSArray *extensionsNames = [extensionsString componentsSeparatedByString:@" "];
    return [extensionsNames containsObject: searchName];
}

@end
