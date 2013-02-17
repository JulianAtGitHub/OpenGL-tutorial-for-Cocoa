//
//  GSOpenGLInfoHelper.h
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 17/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSOpenGLInfoHelper : NSObject

+ (GSOpenGLInfoHelper *)sharedOpenGLInfoHelper;

- (BOOL) checkForGLExtension:(NSString *)searchName;

@end
