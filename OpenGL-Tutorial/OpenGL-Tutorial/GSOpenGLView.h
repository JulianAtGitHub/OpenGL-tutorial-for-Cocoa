//
//  GSOpenGLView.h
//  OpenGL-Tutorial
//
//  Created by wei.zhu on 1/23/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol GSOpenGLViewDelegate;

@interface GSOpenGLView : NSOpenGLView

@property (nonatomic, strong) id<GSOpenGLViewDelegate> delegate;

@end

@protocol GSOpenGLViewDelegate <NSObject>

@required
- (BOOL)prepareRenderData;
- (void)render;

@end

#define Set_OpenGLViewDelegate(classname) \
    classname *delegate = [[classname alloc] init]; \
    self.delegate = delegate; \
    if ([self.delegate respondsToSelector:@selector(prepareRenderData)]) { \
        [self.delegate prepareRenderData]; \
    } \
    NSTimer *timer = [NSTimer timerWithTimeInterval:(1.0/60.0) \
                                             target:self \
                                           selector:@selector(drawRect:) \
                                           userInfo:nil \
                                            repeats:YES]; \
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];