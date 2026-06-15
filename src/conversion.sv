`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2026 08:02:42 AM
// Design Name: 
// Module Name: conversion
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conversion(
    input  logic [3:0] num,
    output logic [4:0] encoded_num
);
    
    // converts user-input (0-9) into morse-format
    // 0: short pulse - 1: long pulse
    always_comb begin
        case(num)
            0: encoded_num = 5'b11111;
            1: encoded_num = 5'b01111;
            2: encoded_num = 5'b00111;
            3: encoded_num = 5'b00011;
            4: encoded_num = 5'b00001;
            5: encoded_num = 5'b00000;
            6: encoded_num = 5'b10000;
            7: encoded_num = 5'b11000;
            8: encoded_num = 5'b11100;
            9: encoded_num = 5'b11110;
            default: encoded_num = 5'b00000;
        endcase   
    end
    
endmodule
