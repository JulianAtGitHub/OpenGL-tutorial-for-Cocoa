//
//  GSOpenGLView.h
//  OpenGL-Tutorial
//
//  Created by wei.zhu on 1/23/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol GSOpenGLViewDelegate;

@interface GSOpenGLView : NSOpenGLView {
    NSTimer *_timer;
}

@property (nonatomic, strong) id<GSOpenGLViewDelegate> delegate;

- (void)visit:(NSTimer*)theTimer;

@end

@protocol GSOpenGLViewDelegate <NSObject>

@required
- (BOOL)prepareRenderData;
- (void)update:(NSTimeInterval)timeInterval;
- (void)render;


@end

#define Set_OpenGLViewDelegate(classname) \
    classname *delegate = [[classname alloc] init]; \
    self.delegate = delegate; \
    if ([self.delegate respondsToSelector:@selector(prepareRenderData)]) { \
        [self.delegate prepareRenderData]; \
    } \
    _timer = [NSTimer timerWithTimeInterval:(1.0/60.0) \
                                     target:self \
                                   selector:@selector(visit:) \
                                   userInfo:nil \
                                    repeats:YES]; \
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];

