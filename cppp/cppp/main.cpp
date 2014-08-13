//
//  main.cpp
//  cppp
//
//  Created by Valor Zhong on 13/08/14.
//  Copyright (c) 2014年 Valor Zhong. All rights reserved.
//

#define GLFW_INCLUDE_GLCOREARB
#include <GLFW/glfw3.h>
#include <stdlib.h>
#include <stdio.h>

static void error_callback(int error, const char* description) {
    fputs(description, stderr);
}

static void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
        glfwSetWindowShouldClose(window, GL_TRUE);
}

int main(void) {
    
    GLFWwindow* window;
    
    glfwSetErrorCallback(error_callback);
    
    if (!glfwInit())
        exit(EXIT_FAILURE);
    
    window = glfwCreateWindow(640, 480, "Simple example", NULL, NULL);
    
    if (!window) {
        glfwTerminate();
        exit(EXIT_FAILURE);
    }
    
    glfwMakeContextCurrent(window);
    glfwSetKeyCallback(window, key_callback);
    
//    GLuint vertexArrayID;
//    glGenVertexArrays(1, &vertexArrayID);
//    glBindVertexArray(vertexArrayID);
    
    static const GLfloat vertex_buffer_data[] = {
        -1.0f, -1.0f, 0.0f,
        1.0f, -1.0f, 0.0f,
        0.0f,  1.0f, 0.0f,
    };
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_buffer_data), vertex_buffer_data, GL_STATIC_DRAW);
    
    while (!glfwWindowShouldClose(window)) {
        
        glClearColor(0.5, 0.6, 0.8, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
        
        glEnableVertexAttribArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (void*)0);
        
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        glDisableVertexAttribArray(0);
        
        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    
    glfwDestroyWindow(window);
    
    glfwTerminate();
    
    exit(EXIT_SUCCESS);
}






















