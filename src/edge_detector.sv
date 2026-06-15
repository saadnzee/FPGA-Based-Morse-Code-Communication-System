`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2026 08:31:19 AM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector( 
    input  logic clk,  
    input  logic rst, 
    input  logic in, 
    output logic out 
); 
    logic r1, r2, r3; 
    always@(posedge clk or posedge rst) begin 
        if(rst) begin 
            r1<=0; 
            r2<=0; 
            r3<=0; 
        end 
        else begin 
            r1<=in; 
            r2<=r1; 
            r3<=r2; 
        end 
    end 
    
    assign out = ~r3 & r2; 
    
endmodule