`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 09:23:13
// Design Name: 
// Module Name: door_look
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


module door_lock(
    input clk,
    input reset,
    input enter,
    input [3:0] digit,
    output reg unlock,
    output reg error
);

    // FSM state encoding using parameters
    parameter IDLE     = 3'd0;
    parameter D1       = 3'd1;
    parameter D2       = 3'd2;
    parameter D3       = 3'd3;
    parameter D4       = 3'd4;
    parameter CHECK    = 3'd5;
    parameter UNLOCKED = 3'd6;
    parameter ERROR_S  = 3'd7;

    reg [2:0] state;

    // Password and entered digits
    reg [3:0] entered[0:3];
    reg [3:0] password[0:3];

    // Initialization
    initial begin
        password[0] = 4;  // Password = 4 1 3 2
        password[1] = 1;
        password[2] = 3;
        password[3] = 2;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            unlock <= 0;
            error <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (enter) begin
                        entered[0] <= digit;
                        state <= D1;
                    end
                end

                D1: begin
                    if (enter) begin
                        entered[1] <= digit;
                        state <= D2;
                    end
                end

                D2: begin
                    if (enter) begin
                        entered[2] <= digit;
                        state <= D3;
                    end
                end

                D3: begin
                    if (enter) begin
                        entered[3] <= digit;
                        state <= CHECK;
                    end
                end

                CHECK: begin
                    if (entered[0] == password[0] &&
                        entered[1] == password[1] &&
                        entered[2] == password[2] &&
                        entered[3] == password[3]) begin
                        unlock <= 1;
                        error <= 0;
                        state <= UNLOCKED;
                    end else begin
                        unlock <= 0;
                        error <= 1;
                        state <= ERROR_S;
                    end
                end

                UNLOCKED: begin
                    // wait for reset
                end

                ERROR_S: begin
                    // wait for reset
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule