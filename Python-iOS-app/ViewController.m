//
//  ViewController.m
//  Python-iOS-app
//
//  Created by Fancyzero on 13-8-21.
//  Copyright (c) 2013年 Fancyzero. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#include "Python.h"

int testPython(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testScriptAction:(UIButton *)sender {
    NSString *srcFile = [[[NSBundle mainBundle] resourcePath]
                         stringByAppendingPathComponent:@"pytest.py"];
    NSString *tarPath = [[AppDelegate documentsPath]
                         stringByAppendingPathComponent:@"pytest.py"];
    [AppDelegate copyFileIfNotExist:srcFile target:tarPath];
    testPython();
}

@end



int testPython(void)
{
    PyObject *modulename, *module, *dic, *func, *args, *rel, *list;
    
    char *funcname1 = "sum";
    
    char *funcname2 = "strsplit";
    
    int i;
    
    Py_ssize_t s;
    
    char modulePath[1024];
    //sprintf(modulePath, "%s/%s", moduleDir, "pytest.py");
    strcpy(modulePath, "pytest");
    
    modulename = Py_BuildValue("s", modulePath);
    module = PyImport_Import(modulename);
    //module = PyImport_ImportModule(modulePath);
    if(!module) {
        printf("导入pytest失败!\n");
        return -1;
    }
    
    /* 获得模块中函数并检验其有效性 */
    dic = PyModule_GetDict(module);
    if (!dic) {
        printf("错误!\n");
        return -1;
    }
    
    /* 获得sum函数地址并验证 */
    func = PyDict_GetItemString(dic,funcname1);
    if(!PyCallable_Check(func)) {
        printf("不能找到函数 %s",funcname1);
        return -1;
    }
    
    /* 构建列表 */
    list = PyList_New(5);
    printf("使用Python中的sum函数求解下列数之和\n");
    for (i = 0; i < 5; i++) {
        printf("%d\t",i);
        PyList_SetItem(list,i,Py_BuildValue("i",i));
    }
    
    printf("\n");
    
    /* 构建sum函数的参数元组*/
    args = PyTuple_New(1);
    PyTuple_SetItem(args,0,list);
    
    /* 调用sum函数 */
    PyObject_CallObject(func,args);
    
    /* 获得strsplit函数地址并验证*/
    func = PyDict_GetItemString(dic,funcname2);
    if(!PyCallable_Check(func)) {
        printf("不能找到函数 %s\n",funcname2);
        return -1;
    }
    
    /* 构建strsplit函数的参数元组 */
    args = PyTuple_New(2);
    
    printf("使用Python中的函数分割以下字符串:\n");
    printf("this is an example\n");
    
    PyTuple_SetItem(args,0,Py_BuildValue("s","this is an example"));
    PyTuple_SetItem(args,1,Py_BuildValue("s"," "));
    
    /* 调用strsplit函数并获得返回值 */
    rel = PyObject_CallObject(func, args);
    s = PyList_Size(rel);
    
    printf("结果如下所示:\n");
    
    for ( i = 0; i < s; i ++) {
        printf("%s\n",PyString_AsString(PyList_GetItem(rel,i)));
    }
    
    /* 释放资源 */
    Py_DECREF(list);
    Py_DECREF(args);
    Py_DECREF(module);
    
    return 0;
}
