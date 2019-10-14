//
//  QSThreadSafeMutableArray.m
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSThreadSafeMutableArray.h"

@interface QSThreadSafeMutableArray()

@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableArray* array;

@end


@implementation QSThreadSafeMutableArray

#pragma mark - init 方法
- (instancetype)initCommon{
    
    self = [super init];
    if (self) {
        //%p 以16进制的形式输出内存地址，附加前缀0x
        NSString* uuid = [NSString stringWithFormat:@"com.buaa.jzp.array_%p", self];
        //注意：_syncQueue是并行队列
        _syncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)init{
    
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems{
    
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}

- (NSArray *)initWithContentsOfFile:(NSString *)path{
    
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [self initCommon];
    if (self) {
        _array = [[NSMutableArray alloc] initWithCoder:aDecoder];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt{
    
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray array];
        for (NSUInteger i = 0; i < cnt; ++i) {
            [_array addObject:objects[i]];
        }
    }
    return self;
}

#pragma mark - 数据操作方法 (凡涉及更改数组中元素的操作，使用异步派发+栅栏块；读取数据使用 同步派发+并行队列)
- (NSUInteger)count{
    
    __block NSUInteger count;
    dispatch_sync(_syncQueue, ^{
        count = self.array.count;
    });
    return count;
}

- (id)objectAtIndex:(NSUInteger)index{
    
    __block id obj;
    dispatch_sync(_syncQueue, ^{
        if (index < [self.array count]) {
            obj = self.array[index];
        }
    });
    return obj;
}

- (NSEnumerator *)objectEnumerator{
    
    __block NSEnumerator *enu;
    dispatch_sync(_syncQueue, ^{
        enu = [self.array objectEnumerator];
    });
    return enu;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    dispatch_barrier_async(_syncQueue, ^{
        if (anObject && index < [self.array count]) {
            [self.array insertObject:anObject atIndex:index];
        }
    });
}

- (void)addObject:(id)anObject{
    
    dispatch_barrier_async(_syncQueue, ^{
        if(anObject){
           [self.array addObject:anObject];
        }
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    
    dispatch_barrier_async(_syncQueue, ^{
        
        if (index < [self.array count]) {
            [self.array removeObjectAtIndex:index];
        }
    });
}

- (void)removeLastObject{
    
    dispatch_barrier_async(_syncQueue, ^{
        [self.array removeLastObject];
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    
    dispatch_barrier_async(_syncQueue, ^{
        if (anObject && index < [self.array count]) {
            [self.array replaceObjectAtIndex:index withObject:anObject];
        }
    });
}

- (NSUInteger)indexOfObject:(id)anObject{
    
    __block NSUInteger index = NSNotFound;
    dispatch_sync(_syncQueue, ^{
        for (int i = 0; i < [self.array count]; i ++) {
            if ([self.array objectAtIndex:i] == anObject) {
                index = i;
                break;
            }
        }
    });
    return index;
}

- (void)dealloc{
    
    if (_syncQueue) {
        _syncQueue = NULL;
    }
}

@end
