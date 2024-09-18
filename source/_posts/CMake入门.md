---
title: CMake入门
tags: Cmake
categories: 718
abbrlink: 63833
date: 2024-01-12 23:55:00
cover: https://imgapi.jinghuashang.cn/random?8
---

### 1 前言

#### 1 .1Cmake是什么

CMake是一个跨平台的安装（编译）工具，可以用简单的语句来描述所有平台的安装(编译过程)。可以构建、测试、打包项目。CMake 用于使用简单的平台和编译器独立配置文件来控制程序编译过程，并生成可在您选择的编译器环境中使用的主机配置文件和项目文件。对于c++工程来说，通过cmake配置，然后通过cmake工具自动生成makefile文件，最后通过make编译出二进制文件。也就是说CMake 用于使用简单的平台和编译器独立配置文件来控制程序编译过程，并生成可在您选择的编译器环境中使用的主机配置文件和项目文件。

<!--more-->

#### 1.2 Cmake 优缺点

- 优点

- - 编程式的配置
  - 支持跨平台
  - 支持强依赖受控管理
  - 官方提供的依赖查找方式
  - 支持配置分离
  - 支持多种外部调用方式
  - 官方提供多种系统检测接口
  - 支持工具链（Toolchain）以传递配置
  - 官方提供了多种工具链实现
  - 自身具有版本控制及约束功能

- 缺点

- - 文档太差。cmake的文档差是一个公认的问题，那官方文档上连一个具体实例都没有，关键点也不会明确体现出来。
  - 弱变量及未定义的变量导致非预期行为。cmake是一个弱语言，其变量没有具体的类型之分。你可以使用某个变量代表一个字符串，也可以代表一个列表。而在其他部分使用此变量作为非预期的类型会导致无穷无尽的问题。当然，这是弱语言的共通问题。而在一处使用未被定义的变量更容易发生未预期的行为。
  - 调试困难。cmake官方目前不支持断点调试功能。

### 2 Cmake环境配置

先安装cmake然后进行环境变量配置即可。 验证是否成功，在命令窗口执行 cmake --verson 即可。

### 3 简单的Cmake工程

```cpp
D:/code/vscodeProject 目录下的文件列表，文档后面都会用到这个路径，后续不在说明。
├─.vscode
├─build
│  ├─.cmak
│  ├─CMakeFiles
│  ├─main
│  ├─src
│  └─Testing
├─exe
├─include
├─main
├─script
└─src
```

通过cmake搭建的一个c++编译工程 链接 github: https://github.com/Persist-Forever/cmakeProc.git

### 4 基本命令

#### 4.1 描述命令

```cpp
cmake_minimum_required(VERSION 3.0.0)  # 指定cmake的最小版本
project(getestProc VERSION 0.1.0)      # 指定项目名称及版本号，初始化项目相关变量
project(getestProc C CXX)                # 指定项目支持的语言 C C++
```

#### 4.2 关键路径

```cpp
# PROJECT_SOURCE_DIR 项目的目录 也就是 D:/code/vscodeProject
MESSAGE(STATUS "This is SOURCE dir "${PROJECT_SOURCE_DIR})
# PROJECT_BINARY_DIR 项目的构建目录 D:/code/vscodeProject/build
MESSAGE(STATUS "This is BINARY dir " ${PROJECT_BINARY_DIR})
```

#### 4.3 设置关键字

SET关键字用来显示指定的变量

```cpp
SET(SRC_LIST XXX.cpp xx2.cpp xx3.cpp ...)
# $<TARGET_OBJECTS:src-dltest-object> 这个设置到一个变量中是因为add_libary可以使用
set(src-dltest
     $<TARGET_OBJECTS:src-dltest-object>
     PARENT_SCOPE)
```

#### 4.4 获取目录下所有源文件

该函数用的比较多，注意不会递归。构建文件中经常使用到这一句。

```cpp
aux_source_directory(. SRC_LIST)
```

#### 4.5 信息打印 MASSAGE关键字

MESSAGE关键字主要用于向终端输出用户自定义的信息，主要包含三种信息

- SEND_ERROR，产生错误，生成过程被跳过
- STATUS，输出前缀为–的信息
- FATAL_ERROR，立即终止所有cmake过程

#### 4.6 add_library

- 第一种用法

```cpp
add_library(<name> [STATIC | SHARED | MODULE]
            [EXCLUDE_FROM_ALL]
            [<source>...])
# 生成 liboptical.so
add_library(optical share optical.cpp ${SRC_LIST})
```

add_library根据源码来生成一个库供他人使用。是个逻辑名称，在项目中必须唯一。完整的库名依赖于具体构建方式（可能为lib.a or .lib）。

STATIC指静态库，SHARED指动态库，MODULE指在运行期通过类似于dlopen的函数动态加载。

- 第二种用法

```cpp
add_library(<name> OBJECT [<source>...])

add_library(... $<TARGET_OBJECTS:name> ...)
add_executable(... $<TARGET_OBJECTS:name> ...)
```

生成一个obj对象，该对象库只编译源文件，但不链接。由add_library()或add_executable()创建的目标可以使用$<TARGET_OBJECTS:name>这样的表达式作为源引用对象，其中，name是对象库的名称。

#### 4.6 add_subdirectory

```cpp
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
# 将 optical otn目录加入到构建系统中，另外参数一般不需要使用
add_subdirectory(optical)
add_subdirectory(otn)
```

将子目录添加到构建系统中。source_dir指定一个目录，其中存放CMakeLists.txt文件和代码文件。binary_dir指定的目录存放输出文件，如果没有指定则使用source_dir。

#### 4.7 add_executable

```cpp
# 第一种：Normal Executables
add_executable(<name> [WIN32] [MACOSX_BUNDLE]
               [EXCLUDE_FROM_ALL]
               [source1] [source2 ...])
# 第二种：Imported Executables
add_executable(<name> IMPORTED [GLOBAL])
# 第三种：Alias Executables
add_executable(<name> ALIAS <target>)

#第一种是项目中经常用到的，这里就用第一种举例
add_executable(main main.cpp ${SRC_LIST})
```

该关键字使用指定的源文件来生成目标可执行文件。具体分为三类：普通、导入、别名。此处我们就以普通可执行文件进行说明，其中是可执行文件的名称，在cmake工程中必须唯一。**WIN32用于在windows下创建一个以WinMain为入口的可执行文件**。MACOSX_BUNDLE用于mac系统或者IOS系统下创建一个GUI可执行应用程序。

#### 4.8 target_link_libraries

```cpp
target_link_libraries(<target> ... <item>... ...)
```

指定链接给定目标和/或其依赖项时要使用的库。命名的必须是由add_executable()或add_library()之类的命令创建的。一般与 link_directories连用（添加外部库的搜索路径 ）

```cpp
# 第一种方式 一般引入第三方库用这种
add_library(hello hello.cpp)        # 生成对象库文件
add_executable(Demo main.cpp)       # 生成可执行文件
target_link_libraries(Demo hello)   # 链接对象库

# 第二种方式  本项目的研发代码链路
add_library(hello OBJECT hello.cpp)  # 生成对象库文件，不链接
add_executable(Demo main.cpp $<TARGET_OBJECTS:hello>)

# 第三种 完全没必要多次一举罗
add_library(hello OBJECT hello.cpp)
add_executable(Demo main.cpp)
target_link_libraries(Demo hello)
```

#### 4.9 include

```cpp
include(<file|module> [OPTIONAL] [RESULT_VARIABLE <VAR>]
                      [NO_POLICY_SCOPE])
# 导入device_cfg.cmake文件 其他参数很少用
include(device_cfg.cmake)
```

从指定的文件加载、运行CMake代码。如果指定文件，则直接处理。如果指定module，则寻找module.cmake文件，首先在${CMAKE_MODULE_PATH}中寻找，然后在CMake的module目录中查找。

#### 4.10 target_include_directories

```cpp
target_include_directories(<target> [SYSTEM] [AFTER|BEFORE]
  <INTERFACE|PUBLIC|PRIVATE> [items1...]
  [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...])
  
# 生成对象库文件
add_library(hello OBJECT hello.cpp) 
# 添加头文件目录
target_include_directories(hello PUBLIC ${CMAKE_SOURCE_DIR}/public)
```

在编译目标文件时指定头文件。必须是通过add_executable()或add_library()创建，且不能是ALIAS目标。<INTERFACE|PUBLIC|PRIVATE>修饰其紧跟参数items的作用范围。

#### 4.11 link_directories

```cpp
link_directories([AFTER|BEFORE] directory1 [directory2 ...])
```

LINK_DIRECTORIES 命令来指定第三方库所在路径，比如，你的动态库在/home/myproject/libs这个路径下，则通过命令：LINK_DIRECTORIES(/home/myproject/libs)，把该路径添加到第三方库搜索路径中，这样就可以使用相对路径了，使用TARGET_LINK_LIBRARIES的时候，只需要给出动态链接库的名字就行了。**官方不建议使用该命令，取而代之的为find_package() find_library()**。

#### 4.12 find_package()

```cpp
## 共支持两种模式
# mode1: Module, 此模式需访问Find<PackageName>.cmake文件
find_package(<PackageName> [version] [EXACT] [QUIET] [MODULE]
             [REQUIRED] [[COMPONENTS] [components...]]
             [OPTIONAL_COMPONENTS components...]
             [NO_POLICY_SCOPE])
find_package(uts MODULE) #去找 Finduts.cmake  注意指定路径

# mode2: Config, 此模式需访问<lowercasePackageName>-config.cmake or <PackageName>Config.cmake
find_package(<PackageName> [version] [EXACT] [QUIET]
             [REQUIRED] [[COMPONENTS] [components...]]
             [OPTIONAL_COMPONENTS components...]
             [CONFIG|NO_MODULE]
             [NO_POLICY_SCOPE]
             [NAMES name1 [name2 ...]]
             [CONFIGS config1 [config2 ...]]
             [HINTS path1 [path2 ... ]]
             [PATHS path1 [path2 ... ]]
             [PATH_SUFFIXES suffix1 [suffix2 ...]]
             [NO_DEFAULT_PATH]
             [NO_PACKAGE_ROOT_PATH]
             [NO_CMAKE_PATH]
             [NO_CMAKE_ENVIRONMENT_PATH]
             [NO_SYSTEM_ENVIRONMENT_PATH]
             [NO_CMAKE_PACKAGE_REGISTRY]
             [NO_CMAKE_BUILDS_PATH] # Deprecated; does nothing.
             [NO_CMAKE_SYSTEM_PATH]
             [NO_CMAKE_SYSTEM_PACKAGE_REGISTRY]
             [CMAKE_FIND_ROOT_PATH_BOTH |
              ONLY_CMAKE_FIND_ROOT_PATH |
              NO_CMAKE_FIND_ROOT_PATH])
```

find_package一般用于加载外部库到项目中，并且会加载库的细节信息。如上find_package有两种模式：Module与Config。

该命令描述特别复杂，参考博客： [(41条消息) CMake中find_package的使用_fengbingchun的博客-CSDN博客](https://blog.csdn.net/fengbingchun/article/details/127473202)

#### 4.13 find_libary()

该函数用于库查找

```cpp
find_library(
          <VAR>
          name | NAMES name1 [name2 ...] [NAMES_PER_DIR]
          [HINTS [path | ENV var]... ]
          [PATHS [path | ENV var]... ]
          [REGISTRY_VIEW (64|32|64_32|32_64|HOST|TARGET|BOTH)]
          [PATH_SUFFIXES suffix1 [suffix2 ...]]
          [DOC "cache documentation string"]
          [NO_CACHE]
          [REQUIRED]
          [NO_DEFAULT_PATH]
          [NO_PACKAGE_ROOT_PATH]
          [NO_CMAKE_PATH]
          [NO_CMAKE_ENVIRONMENT_PATH]
          [NO_SYSTEM_ENVIRONMENT_PATH]
          [NO_CMAKE_SYSTEM_PATH]
          [NO_CMAKE_INSTALL_PREFIX]
          [CMAKE_FIND_ROOT_PATH_BOTH |
           ONLY_CMAKE_FIND_ROOT_PATH |
           NO_CMAKE_FIND_ROOT_PATH]
)
# 在默认路径下查找/usr/lib/...  libJSON-C.so
find_libary(json NAMES JSON-C)
```

详细介绍见参考博客： [(41条消息) CMake中find_library的使用_fengbingchun的博客-CSDN博客](https://blog.csdn.net/fengbingchun/article/details/127232175)

### 5 场景实战

该章节的是为了更好的将cmake应用在构建工程中，分不同场景来练习和实战，将多条cmake命令组合起来完成各种场景的需求。这样才能更好的使用cmake.一些场景后续根据实际需求补上。

#### 5.1 一个目录一个object

将一个目录下的源文件通过一个makelist.txt文件编译成一个 object，这样有利于代码结构化管理。

```cpp
aux_source_directory(. SRC_LIST)
add_library(src-dltest-object OBJECT $(SRC_LIST))
set(src-dltest
     $<TARGET_OBJECTS:src-dltest-object>
     PARENT_SCOPE)
set(LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib/)
set(src
    ${src-dltest}
    PARENT_SCOPE)
```

#### 5.2 编译链 toolchain

```cpp
# -Dxxx指定编译参数  cmake和makelist里面可以用变量 LLT  CPU_BIT_FLAG 等
cmake .. -DCOMPILER="${platform}" -DMODULE="${module}" -DLLT="true" -DCPU_BIT_FLAG="FLAG_64" 
-DCMAKE_TOOLCHAIN_FILE="${root_path}"/cmake/toolchain/"${platform}"_toolchain.cmake
#  编译链cmake 主要设置编译选项等 x86_toolchain.cmake
set(CMAKE_C_FLAGS " -Wall -Werror -Wfloat-equal -Wshadow XXX")
set(CMAKE_CXX_FLAGS " -g -m64 -std=c++17 -Wall -Werror -Wfloat-equal -Wshadow XXX")
```

#### 5.3 第三方库引入

```cpp
# 方式一 制定绝对路径
set(xxx_path xxxx)
set(xxx_lib_path ${xxx_path}/lib)
set(xxx_include_path ${xxx_path}/include)

# 方式二 find_package  find_path  find_library
find_package(thirdParty REQUIRED)
# 自动寻找 FindthirdParty.cmake, 路径会根据find_package的规则寻找
- thirdParty
	- party
get_filename_component(THIRDPARTY_ROOT  "${CMAKE_CURRENT_LIST_DIR}/xxx/thirdParty" ABSOLUTE)

find_path(THIRDPARTY_INCLUDE_PATH  party
    HINTS         ${THIRDPARTY_ROOT}
    PATH_SUFFIXES  include)
find_package_handle_standard_args(thirdParty REQUIRED_VARS THIRDPARTY_INCLUDE_PATH)
find_path(THIRDPARTY_LIB_PATH  libdrv_thirdParty.so
    HINTS         ${THIRDPARTY_ROOT}
    PATH_SUFFIXES lib)
find_package_handle_standard_args(thirdParty REQUIRED_VARS THIRDPARTY_LIB_PATH)
```

### 6 总结

本文通过六个章节对cmake做了一定的介绍，其中第一章节属于cmake是用来干啥的和优缺点做了说明，第二三章节简要说明了cmake环境配置和一个简单的cmake工程github上可下载。第四章节是一些常用命令的介绍和学习。第五章节是一些场景实战，目前场景比较少，后续根据实际慢慢补上。第六章节是对整篇文章做个总结。

总体来说，cmake是一们比较容易的语言，系统/项目构建中用的比较多，对于程序员来说都应该对构建有一定的了解和实战经验。也许我们会觉得ide使用起来比较方便，但ide只适合实际学习语言的时候使用。真正开发的构建工程大部分使用cmake来搭建的。
