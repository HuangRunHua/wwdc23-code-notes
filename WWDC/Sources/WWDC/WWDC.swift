// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(init))
/// 定义了`SlopeSubset()`后在使用的时候采用语法`@SlopeSubset`添加关键词
/// `module`用于指明`macro`内部的实现将在哪里定义
/// `type`内的参数值必须和`WWDCMacro`中定义的公开结构体的名字相同
public macro SlopeSubset() = #externalMacro(module: "WWDCMacros", type: "SlopeSubsetMacro")
