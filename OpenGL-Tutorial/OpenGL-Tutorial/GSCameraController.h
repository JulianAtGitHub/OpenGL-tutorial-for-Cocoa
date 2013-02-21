//
//  GSCameraController.h
//  OpenGL-Tutorial
//
//  Created by 朱 巍 on 21/2/13.
//  Copyright (c) 2013 Juicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kazmath/kazmath.h"
#import "GSInputController.h"

@interface GSCameraController : NSObject<GSInputDelegate>

@property (nonatomic, readonly) kmVec3 eye;
@property (nonatomic, readonly) kmVec3 center;
@property (nonatomic, readonly) kmVec3 up;
@property (nonatomic, readwrite) float moveSpeed;
@property (nonatomic, readwrite) float rotateSpeed;
@property (nonatomic, readwrite) float fov;
@property (nonatomic, readwrite) float aspect;
@property (nonatomic, readwrite) float near;
@property (nonatomic, readwrite) float far;

- (id)initWithEye:(kmVec3)eye Center:(kmVec3)center Up:(kmVec3)up;

- (kmMat4)viewMatrix;
- (kmMat4)perspectiveMatrix;

@end
