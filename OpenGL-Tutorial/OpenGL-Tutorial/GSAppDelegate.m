//
//  GSAppDelegate.m
//  OpenGL-Tutorial
//
//  Created by wei.zhu on 1/23/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import "GSAppDelegate.h"
#import "GSOpenGLView.h"
#import "GSOpenGLInfoHelper.h"

@implementation GSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSOpenGLPixelFormatAttribute attributes[] = {
        NSOpenGLPFAColorSize, 32,
        NSOpenGLPFADepthSize, 16,
        NSOpenGLPFAStencilSize, 8,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAAccelerated,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
        0
    };
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    if (pixelFormat == nil) {
        NSLog(@"Faild create pixel format");
        return;
    }
    
    NSOpenGLView *view = [[GSOpenGLView alloc] initWithFrame:self.window.frame pixelFormat:pixelFormat];
    
    [self.window setContentView:view];
    
    //GSOpenGLInfoHelper *openGLInfoHelp = [GSOpenGLInfoHelper sharedOpenGLInfoHelper];
}

@end
