`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 09:26:30
// Design Name: 
// Module Name: door_lock_tb
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


module door_lock_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg enter;
    reg [3:0] digit;
    wire unlock;
    wire error;

    // Instantiate the DUT (Device Under Test)
    door_lock uut (.clk(clk), .reset(reset), .enter(enter), .digit(digit), .unlock(unlock), .error(error));

    // Clock generator (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to enter a 4-digit password
    task enter_password(input [3:0] d0, d1, d2, d3);
    begin
        digit = d0; enter = 1; #10; enter = 0; #10;
        digit = d1; enter = 1; #10; enter = 0; #10;
        digit = d2; enter = 1; #10; enter = 0; #10;
        digit = d3; enter = 1; #10; enter = 0; #10;
    end
    endtask

    // Main test procedure
    initial begin
        $display("===== Starting Self-Checking Testbench =====");

        // Initialize
        reset = 1;
        enter = 0;
        digit = 0;
        #10 reset = 0;

        // Test 1: Correct Password (4 1 3 2)
        $display("Test 1: Entering correct password 4-1-3-2");
        enter_password(4, 1, 3, 2);
        #20;
        if (unlock == 1 && error == 0)
            $display("PASS: Correct password unlocked the system.");
        else
            $display("FAIL: Correct password did not unlock the system.");

        // Reset system
        reset = 1; #10; reset = 0;

        // Test 2: Wrong Password (1 2 3 4)
        $display("Test 2: Entering wrong password 1-2-3-4");
        enter_password(1, 2, 3, 4);
        #20;
        if (unlock == 0 && error == 1)
            $display("PASS: Wrong password correctly triggered error.");
        else
            $display("FAIL: Wrong password did not trigger error as expected.");

        $display("===== Testbench Finished =====");
        $finish;
    end

endmodule