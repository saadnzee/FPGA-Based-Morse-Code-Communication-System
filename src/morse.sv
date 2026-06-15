`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2026 08:13:30 AM
// Design Name: 
// Module Name: morse
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


module morse(
    input  logic       clk,         // 100MHz clock
    input  logic       rst,         // async-reset
    input  logic       load_en,     // loads value into digit_mem
    input  logic       start_en,    
    input  logic       mode,        // (0: digit-mode, 1: number-mode)
    input  logic [3:0] num,         // captures raw user input via slide-switches (0-9)
    output logic       led_out      // displays the final morse code 
);

    logic [4:0] digit_mem [0:5];        // Width: 5-bit, Depth: 6
    logic [4:0] digit_mem_content;      // what is read from digit_mem in LOAD state
    logic [2:0] wt_pointer;             // keeps track of how many digits have been stored in digit_mem
    logic [2:0] rd_pointer;             // keeps track of how many digits have been loaded from digit_mem
    logic       bit_processing;         // the current bit that is being processed within digit_mem_content
    
    // -------------------------
    // --- counter registers ---
    // -------------------------
    logic [28:0] count_3;
    logic [27:0] count_2;
    logic [26:0] count_1;
    logic [25:0] count_0_5;
    
    // --- tracks the current morse symbol index (0-4) ---
    logic [2:0] sym_cnt;               
    
    // ----------------------
    // --- Edge Detection ---
    // ----------------------
    logic start_en_edge;            // used for transitioning between states
    logic load_en_edge;             // used to write into digit memory and to increment wt_pointer
    
    edge_detector ed0 (.clk(clk), .rst(rst), .in(start_en), .out(start_en_edge));
    edge_detector ed1 (.clk(clk), .rst(rst), .in(load_en), .out(load_en_edge));
    
    // ----------------------------
    // --- Finite State Machine ---
    // ----------------------------
    logic [2:0] state, next_state;
    
    localparam  IDLE       = 'd0,
                STORE      = 'd1,
                LOAD       = 'd2,
                DISP       = 'd3,
                CNT_SYM    = 'd4,
                GAP        = 'd5,
                DIGIT_GAP  = 'd6;
                
    always_ff@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
       
    always_comb begin
        next_state = state;
        case(state)
            IDLE: next_state = (start_en_edge) ? STORE :  IDLE;
            STORE: next_state = (start_en_edge || wt_pointer == 'd6) ? LOAD :  STORE;
            LOAD: next_state = DISP;
            DISP: next_state = (count_3 == 29'd300_000_000 || count_1 == 27'd100_000_000) ? CNT_SYM : DISP;
            CNT_SYM: next_state = (sym_cnt == 3'd4) ? DIGIT_GAP : GAP;
            GAP: begin 
                if(count_0_5 == 26'd50_000_000) begin
                    next_state = DISP;
                end
                else next_state = GAP;
            end
            DIGIT_GAP: begin
                if(mode==0) next_state = IDLE;
                else begin
                    if(rd_pointer < wt_pointer) begin
                        next_state = (count_2 == 28'd200_000_000) ? LOAD : DIGIT_GAP; 
                    end
                    else next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end
    
    // ---------------------------------------------------
    // --- Converting raw user input into morse format ---
    // ---------------------------------------------------
    logic [4:0] encoded_num;
    conversion conv (.num(num), .encoded_num(encoded_num));
    
    // -------------------
    // --- STORE Logic ---
    // -------------------
    always_ff@(posedge clk or posedge rst) begin
        if(rst || state == IDLE) begin
            for(int i = 0; i < 6; i++) digit_mem[i] <= 0; 
        end
        else if(state == STORE && load_en_edge) digit_mem[wt_pointer] <= encoded_num;
    end
    
    always_ff@(posedge clk or posedge rst) begin
        if(rst || state == IDLE) wt_pointer <= 'd0;
        else if(state == STORE && load_en_edge) wt_pointer <= wt_pointer + 'd1;
    end    
    
    // ------------------
    // --- LOAD Logic ---
    // ------------------
    always_ff@(posedge clk or posedge rst) begin
        if(rst || state==IDLE) digit_mem_content <= 5'd0;
        else if(state==LOAD)  digit_mem_content <= digit_mem[rd_pointer];
    end

    always_ff@(posedge clk or posedge rst) begin
        if(rst || state == IDLE) rd_pointer <= 'd0;
        else if(state==LOAD) rd_pointer <= rd_pointer + 'd1;
    end
    
    // ==================
    // ==== Counters ====
    // ==================
    always_ff@(posedge clk or posedge rst) begin
        if(rst || count_3 == 29'd300_000_000) count_3 <= 29'd0;
        else if (state==DISP && bit_processing == 1'b1) count_3 <= count_3 + 29'd1;
    end
    always_ff@(posedge clk or posedge rst) begin
        if(rst || count_2 == 28'd200_000_000) count_2 <= 28'd0;
        else if (state==DIGIT_GAP) count_2 <= count_2 + 28'd1;
    end
    always_ff@(posedge clk or posedge rst) begin
        if(rst || count_1 == 27'd100_000_000) count_1 <= 27'd0;
        else if (state==DISP && bit_processing == 1'b0) count_1 <= count_1 + 27'd1;
    end
    always_ff@(posedge clk or posedge rst) begin
        if(rst || count_0_5 == 26'd50_000_000) count_0_5 <= 26'd0;
        else if (state==GAP) count_0_5 <= count_0_5 + 26'd1;
    end

    // --------------------
    // --- Symbol Logic ---
    // --------------------
    always_ff@(posedge clk or posedge rst) begin
        if(rst || state == IDLE || state == LOAD) sym_cnt <= 3'd0;
        else if(state == CNT_SYM) sym_cnt <= sym_cnt + 3'd1;
    end
    
    always_comb begin
        bit_processing = digit_mem_content[sym_cnt];
    end
    
    // --------------------
    // --- output-logic ---
    // --------------------
    always_comb begin
        if(state == DISP) led_out = 1;
        else led_out = 0;
    end
    
endmodule
