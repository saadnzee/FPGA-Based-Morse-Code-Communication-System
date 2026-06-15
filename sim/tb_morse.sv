`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2026 08:49:11 AM
// Design Name: 
// Module Name: tb_morse
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


module tb_morse();

    logic clk, rst, mode, load_en, start_en, led_out;
    logic [3:0] num;
    
    morse dut (.clk(clk), .rst(rst), .mode(mode), .load_en(load_en), .start_en(start_en), .num(num), .led_out(led_out));
    
    always #5 clk = ~clk;
    
    initial begin
    
        clk = 0;
        rst = 1;
        
        mode = 0;
        load_en = 0;
        start_en = 0;
        
        num = 4;
        
        #10
        
        start_en = 1;
        rst = 0;
        
//        #15
        
//        load_en = 1;
        
//        #15
        
//        load_en = 0;
//        start_en = 0;
        
//        #15
        
//        start_en = 1;
        
//        #15
        
//        start_en = 0;
              
        $finish;    
    end

endmodule
