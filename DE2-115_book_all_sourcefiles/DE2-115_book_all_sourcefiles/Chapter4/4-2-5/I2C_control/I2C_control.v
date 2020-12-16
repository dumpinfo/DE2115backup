// Copyright (C) 1991-2010 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions
// and other software and tools, and its AMPP partner logic
// functions, and any output files from any of the foregoing
// (including device programming or simulation files), and any
// associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License
// Subscription Agreement, Altera MegaCore Function License
// Agreement, or other applicable license agreement, including,
// without limitation, that your use is for the sole purpose of
// programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the
// applicable agreement for further details.

// Generated by Quartus II Version 10.0 Build 218 06/27/2010 SJ Full Version
// Created on Sun Sep 05 11:57:17 2010

// synthesis message_off 10175

`timescale 1ns/1ns

module I2C_control (
        reset,CLK,GO,bitcount,
        SCLK_Temp,bitcountEN,rstbitcount,LDEN,ldnACK1,ldnACK2,ldnACK3,rstACK,SHEN,SDO,SCLK);

    input reset;
    input CLK;
    input GO;
    input [4:0] bitcount;
    tri0 reset;
    tri0 GO;
    tri0 [4:0] bitcount;
    output SCLK;
    output SCLK_Temp;
    output bitcountEN;
    output rstbitcount;
    output LDEN;
    output ldnACK1;
    output ldnACK2;
    output ldnACK3;
    output rstACK;
    output SHEN;
    output SDO;
    reg SCLK_Temp;
    reg bitcountEN;
    reg rstbitcount;
    reg LDEN;
    reg ldnACK1;
    reg ldnACK2;
    reg ldnACK3;
    reg rstACK;
    reg SHEN;
    reg SDO;
    reg [7:0] fstate;
    reg [7:0] reg_fstate;
    parameter X_IDLE=0,X_GO=1,X_START=2,X_WAIT=3,X_SHIFT=4,X_STOP=5,X_FINAL=6,X_END=7;
    assign SCLK = SHEN? ~CLK: SCLK_Temp;
    always @(posedge CLK or posedge reset)
    begin
        if (reset)
        begin
            fstate <= X_IDLE;
        end
        else
        begin
            fstate <= reg_fstate;
        end
    end

    always @(fstate or GO or bitcount)
    begin
        SCLK_Temp <= 1'b0;
        bitcountEN <= 1'b0;
        rstbitcount <= 1'b0;
        LDEN <= 1'b0;
        ldnACK1 <= 1'b0;
        ldnACK2 <= 1'b0;
        ldnACK3 <= 1'b0;
        rstACK <= 1'b0;
        SHEN <= 1'b0;
        SDO <= 1'b0;
        case (fstate)
            X_IDLE:
            begin
                if (GO)
                    reg_fstate <= X_GO;
                else if (~(GO))
                    reg_fstate <= X_IDLE;
                // Inserting 'else' block to prevent latch inference
                else
                    reg_fstate <= X_IDLE;


                SCLK_Temp <= 1'b1;
                bitcountEN <= 1'b0;
                rstbitcount <= 1'b0;
                LDEN <= 1'b0;
                ldnACK1 <= 1'b0;
                ldnACK2 <= 1'b0;
                ldnACK3 <= 1'b0;
                rstACK <= 1'b0;
                SHEN <= 1'b0;
                SDO <= 1'b1;
            end
            X_GO:
            begin
                reg_fstate <= X_START;

                SCLK_Temp <= 1'b1;
                bitcountEN <= 1'b0;
                rstbitcount <= 1'b0;
                LDEN <= 1'b1;
                ldnACK1 <= 1'b0;
                ldnACK2 <= 1'b0;
                ldnACK3 <= 1'b0;
                rstACK <= 1'b0;
                SHEN <= 1'b0;
                SDO <= 1'b1;
            end
            X_START:
            begin
                reg_fstate <= X_WAIT;

                SCLK_Temp <= 1'b1;
                bitcountEN <= 1'b0;
                rstbitcount <= 1'b0;
                LDEN <= 1'b0;
                ldnACK1 <= 1'b0;
                ldnACK2 <= 1'b0;
                ldnACK3 <= 1'b0;
                rstACK <= 1'b0;
                SHEN <= 1'b0;
                SDO <= 1'b0;
            end
            X_WAIT:
            begin
                reg_fstate <= X_SHIFT;

                SCLK_Temp <= 1'b1;
                bitcountEN <= 1'b0;
                rstbitcount <= 1'b0;
                LDEN <= 1'b0;
                ldnACK1 <= 1'b0;
                ldnACK2 <= 1'b0;
                ldnACK3 <= 1'b0;
                rstACK <= 1'b0;
                SHEN <= 1'b0;
                SDO <= 1'b0;
            end
            X_SHIFT:
            begin
                if ((bitcount[4:0] == 5'b11010))
                    reg_fstate <= X_STOP;
                else if ((bitcount[4:0] < 5'b11010))
                    reg_fstate <= X_SHIFT;
                // Inserting 'else' block to prevent latch inference
                else
                    reg_fstate <= X_SHIFT;

                SCLK_Temp <= 1'b0;

                bitcountEN <= 1'b1;

                if ((bitcount[4:0] < 5'b11010))
                    rstbitcount <= 1'b0;
                else if ((bitcount[4:0] == 5'b11010))
                    rstbitcount <= 1'b1;
                // Inserting 'else' block to prevent latch inference
                else
                    rstbitcount <= 1'b0;

                LDEN <= 1'b0;
                if ((bitcount[4:0] != 5'b01000))
                    ldnACK1 <= 1'b0;
                else if ((bitcount[4:0] == 5'b01000))
                    ldnACK1 <= 1'b1;
                else
                    ldnACK1 <= 1'b0;

                if ((bitcount[4:0] != 5'b10001))
                    ldnACK2 <= 1'b0;
                else if ((bitcount[4:0] == 5'b10001))
                    ldnACK2 <= 1'b1;
                else
                    ldnACK2 <= 1'b0;

                if ((bitcount[4:0] != 5'b11010))
                    ldnACK3 <= 1'b0;
                else if ((bitcount[4:0] == 5'b11010))
                    ldnACK3 <= 1'b1;
                else
                    ldnACK3 <= 1'b0;

                rstACK <= 1'b0;
                SHEN <= 1'b1;
                SDO <= 1'b1;
            end
            X_STOP:
            begin
                reg_fstate <= X_FINAL;

                SCLK_Temp <= 1'b0;
                bitcountEN <= 1'b0;
                rstbitcount <= 1'b0;
                LDEN <= 1'b0;
                ldnACK1 <= 1'b0;
                ldnACK2 <= 1'b0;
                ldnACK3 <= 1'b0;
                rstACK <= 1'b0;
                SHEN <= 1'b0;
                SDO <= 1'b0;
            end
            X_FINAL:
            begin
                reg_fstate <= X_END;

                SCLK_Temp <= 1'b1;
                bitcountEN <= 1'b0;
                rstbitcount <= 1'b0;
                LDEN <= 1'b0;
                ldnACK1 <= 1'b0;
                ldnACK2 <= 1'b0;
                ldnACK3 <= 1'b0;
                rstACK <= 1'b0;
                SHEN <= 1'b0;
                SDO <= 1'b0;
            end
            X_END:
            begin
                reg_fstate <= X_IDLE;

                SCLK_Temp <= 1'b1;
                bitcountEN <= 1'b0;
                rstbitcount <= 1'b0;
                LDEN <= 1'b0;
                ldnACK1 <= 1'b0;
                ldnACK2 <= 1'b0;
                ldnACK3 <= 1'b0;
                rstACK <= 1'b1;
                SHEN <= 1'b0;
                SDO <= 1'b1;
            end
            default:
            begin
                SCLK_Temp <= 1'bx;
                bitcountEN <= 1'bx;
                rstbitcount <= 1'bx;
                LDEN <= 1'bx;
                ldnACK1 <= 1'bx;
                ldnACK2 <= 1'bx;
                ldnACK3 <= 1'bx;
                rstACK <= 1'bx;
                SHEN <= 1'bx;
                SDO <= 1'bx;
                $display ("Reach undefined state");
            end
        endcase
    end
endmodule // I2C_control
