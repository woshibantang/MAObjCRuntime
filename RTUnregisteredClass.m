
#import "RTUnregisteredClass.h"

#import "RTProtocol.h"
#import "RTIvar.h"
#import "RTMethod.h"


@implementation RTUnregisteredClass

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (Class)superclass
{
    return [[[self alloc] initWithName: name withSuperclass: superclass] autorelease];
}

+ (id)unregisteredClassWithName: (NSString *)name
{
    return [self unregisteredClassWithName: name withSuperclass: Nil];
}

- (id)initWithName: (NSString *)name withSuperclass: (Class)superclass
{
    if((self = [self init]))
    {
        _class = objc_allocateClassPair(superclass, [name UTF8String], 0);
    }
    return self;
}

- (id)initWithName: (NSString *)name
{
    return [self initWithName: name withSuperclass: Nil];
}

- (void)addProtocol: (RTProtocol *)protocol
{
    class_addProtocol(_class, [protocol objCProtocol]);
}

- (void)addIvar: (RTIvar *)ivar
{
    const char *typeStr = [[ivar typeEncoding] UTF8String];
    NSUInteger size, alignment;
    NSGetSizeAndAlignment(typeStr, &size, &alignment);
    class_addIvar(_class, [[ivar name] UTF8String], size, log2(alignment), typeStr);
}

- (void)addMethod: (RTMethod *)method
{
    class_addMethod(_class, [method selector], [method implementation], [[method signature] UTF8String]);
}

- (Class)registerClass
{
    objc_registerClassPair(_class);
    return _class;
}

@end
