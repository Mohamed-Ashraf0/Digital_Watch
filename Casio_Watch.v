module Casio_Watch
#(
    parameter CLKS_PER_SEC = 1
)
(
    input  wire clk,
    input  wire rst,
    input  wire mode_button,
    input  wire set_split_button,
    output reg  [3:0] disp_d3,
    output reg  [3:0] disp_d2,
    output reg  [3:0] disp_d1,
    output reg  [3:0] disp_d0,
    output reg        alarm_on
);
    // ----------------------------------------------------
    // FSM State
    // ----------------------------------------------------
    localparam NORMAL_MODE                = 4'd0,
               TIME_HOURS_TENS_MODE       = 4'd1,
               TIME_HOURS_ONES_MODE       = 4'd2,
               TIME_MINUTES_TENS_MODE     = 4'd3,
               TIME_MINUTES_ONES_MODE     = 4'd4,
               ALARM_HOURS_TENS_MODE      = 4'd5,
               ALARM_HOURS_ONES_MODE       = 4'd6,
               ALARM_MINUTES_TENS_MODE      = 4'd7,
               ALARM_MINUTES_ONES_MODE      = 4'd8,
               STOPWATCH_MODE             = 4'd9;
    
    reg [3:0] CS, NS;

    // ------------------------------------------------
    // Normal mode timer handlers
    // ------------------------------------------------
    reg [10:0] clk_cnt_nm;   // counts 0..60*CLKS_PER_SEC
    wire stop_clk_cnt_nm;
    wire min_tick;
    reg[3:0]time_H2;
    reg[3:0]time_H1;
    reg[3:0]time_M2;
    reg[3:0]time_M1;
    // ------------------------------------------------
    // Stop Watch mode timer handlers
    // ------------------------------------------------
    reg [5:0] clk_cnt_swm;   // counts 0..CLKS_PER_SEC
    wire sec_tick;
    reg[3:0]stop_watch_M2;
    reg[3:0]stop_watch_M1;
    reg[3:0]stop_watch_S2;
    reg[3:0]stop_watch_S1;
    reg[3:0]split_stop_watch_M2;
    reg[3:0]split_stop_watch_M1;
    reg[3:0]split_stop_watch_S2;
    reg[3:0]split_stop_watch_S1;
    wire rst_stop_watch;
    reg split_mode;
    

    // ------------------------------------------------
    // Alarm mode timer handlers
    // ------------------------------------------------
    reg[3:0]alarm_time_H2;
    reg[3:0]alarm_time_H1;
    reg[3:0]alarm_time_M2;
    reg[3:0]alarm_time_M1;

    // ------------------------------------------------
    // set_split button handlers
    // ------------------------------------------------
    reg set_split_button_d;
    // ------------------------------------------------
    //logic for modes flags
    // ------------------------------------------------
    assign stop_clk_cnt_nm = (CS==ALARM_HOURS_TENS_MODE || CS==ALARM_HOURS_ONES_MODE || CS==ALARM_MINUTES_TENS_MODE || CS==ALARM_MINUTES_ONES_MODE);//when setting time stope clk from counting
    assign rst_stop_watch = (CS==NORMAL_MODE); //finish stop watch mode and returned to normal mode
    // ------------------------------------------------
    // Count 60*CLKS_PER_SEC clk ticks → minute tick BLOCK
    // ------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_cnt_nm <= 11'd0;
        else if (clk_cnt_nm == 60*CLKS_PER_SEC-1)
            clk_cnt_nm <= 11'd0;
        else if (stop_clk_cnt_nm)
            clk_cnt_nm <= clk_cnt_nm;
        else
            clk_cnt_nm <= clk_cnt_nm + 1'b1;
    end

    assign min_tick =  (clk_cnt_nm == 60*CLKS_PER_SEC-1);

    // ------------------------------------------------
    // Minutes counter BLOCK :increment by minutes in time
    // ------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            time_H2 <= 4'd0;
            time_H1 <= 4'd0;
            time_M2 <= 4'd0;
            time_M1 <= 4'd0;
        end
        else if (min_tick) begin
            if (time_M1 == 9) begin
                time_M1 <= 0;

                if (time_M2 == 5) begin
                    time_M2 <= 0;

                    if (time_H2 == 2 && time_H1 == 3) begin
                        time_H2 <= 0;
                        time_H1 <= 0;
                    end
                    else if (time_H1 == 9) begin
                        time_H1 <= 0;
                        time_H2 <= time_H2 + 1;
                    end
                    else begin
                        time_H1 <= time_H1 + 1;
                    end
                end
                else begin
                    time_M2 <= time_M2 + 1;
                end
            end
            else begin
                time_M1 <= time_M1 + 1;
            end
        end
        else begin
            time_H2 <= time_H2;
            time_H1 <= time_H1;
            time_M2 <= time_M2;
            time_M1 <= time_M1;
        end 
    end



    // ------------------------------------------------
    // Count CLKS_PER_SEC clk ticks → sec tick BLOCK
    // ------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_cnt_swm <= 6'd0;
        else if (clk_cnt_swm == CLKS_PER_SEC-1)
            clk_cnt_swm <= 6'd0;
        else if (CS==STOPWATCH_MODE )
            clk_cnt_swm <= clk_cnt_swm + 1'b1;
        else
            clk_cnt_swm <= 6'd0;
    end

    assign sec_tick =  (clk_cnt_swm == CLKS_PER_SEC-1);

    // ------------------------------------------------
    // seconds counter BLOCK
    // ------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stop_watch_M2 <= 4'd0;
            stop_watch_M1 <= 4'd0;
            stop_watch_S2 <= 4'd0;
            stop_watch_S1 <= 4'd0;
        end
        else if (sec_tick) begin
        if (stop_watch_S1 == 9) begin
            stop_watch_S1 <= 0;
            if (stop_watch_S2 == 5) begin
                stop_watch_S2 <= 0;
                if (stop_watch_M2 == 5 && stop_watch_M1 == 9) begin
                    stop_watch_M2 <= 0;
                    stop_watch_M1 <= 0;
                end
                else if (stop_watch_M1 == 9) begin
                    stop_watch_M1 <= 0;
                    stop_watch_M2 <= stop_watch_M2 + 1;
                end
                else begin
                    stop_watch_M1 <= stop_watch_M1 + 1;
                end
            end
            else begin
                stop_watch_S2 <= stop_watch_S2 + 1;
            end
        end
        else begin
            stop_watch_S1 <=stop_watch_S1 + 1;
        end
        end
        else if (rst_stop_watch) begin
            stop_watch_M2 <= 0;
            stop_watch_M1 <= 0;
            stop_watch_S2 <= 0;
            stop_watch_S1 <= 0;
        end
        else begin
            stop_watch_M2 <= stop_watch_M2;
            stop_watch_M1 <= stop_watch_M1;
            stop_watch_S2 <= stop_watch_S2;
            stop_watch_S1 <= stop_watch_S1;
        end 
    end
    // ------------------------------------------------
    // sequentiional logic for state transition BLOCK
    // ------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            CS<=0;
        end
        else begin
            CS<=NS;
        end
    end

    // ------------------------------------------------
    // sequentiional logic for set_state button click
    // ------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
                split_stop_watch_M2 <= stop_watch_M2;
                split_stop_watch_M1 <= stop_watch_M1;
                split_stop_watch_S2 <= stop_watch_S2;
                split_stop_watch_S1 <= stop_watch_S1;
        end
        else begin
            if (set_split_button) begin
                case (CS)
                NORMAL_MODE:begin 
                    //nothing to do   
                end
                TIME_HOURS_TENS_MODE:begin
                    if (time_H1 > 4)
                        time_H2 <=
                            (time_H2 >= 1) ? 0 : time_H2 + 1;
                    else
                        time_H2 <=
                            (time_H2 == 2) ? 0 : time_H2 + 1;
                end
                TIME_HOURS_ONES_MODE:begin
                    if (time_H2 == 2)
                        time_H1 <=
                            (time_H1 == 3) ? 0 : time_H1 + 1;
                    else
                        time_H1 <=
                            (time_H1 == 9) ? 0 : time_H1 + 1;
                end
                TIME_MINUTES_TENS_MODE:begin
                    time_M2 <=
                        (time_M2 == 5) ? 0 : time_M2 + 1;
                end
                TIME_MINUTES_ONES_MODE:begin
                    time_M1 <=
                        (time_M1 == 9) ? 0 : time_M1 + 1;
                end
                ALARM_HOURS_TENS_MODE:begin 
                    if (alarm_time_H1 > 4)
                        alarm_time_H2 <=
                            (alarm_time_H2 >= 1) ? 0 : alarm_time_H2 + 1;
                    else
                        alarm_time_H2 <=
                            (alarm_time_H2 == 2) ? 0 : alarm_time_H2 + 1;
                end
                ALARM_HOURS_ONES_MODE:begin
                    if (alarm_time_H2 == 2)
                        alarm_time_H1 <=
                            (alarm_time_H1 == 3) ? 0 : alarm_time_H1 + 1;
                    else
                        alarm_time_H1 <=
                            (alarm_time_H1 == 9) ? 0 : alarm_time_H1 + 1;
                end
                ALARM_MINUTES_TENS_MODE:begin
                    alarm_time_M2 <=
                        (alarm_time_M2 == 5) ? 0 : alarm_time_M2 + 1;
                end
                ALARM_MINUTES_ONES_MODE:begin
                    alarm_time_M1 <=
                        (alarm_time_M1 == 9) ? 0 : alarm_time_M1 + 1;
                end
                STOPWATCH_MODE:begin
                    split_stop_watch_M2 <= stop_watch_M2;
                    split_stop_watch_M1 <= stop_watch_M1;
                    split_stop_watch_S2 <= stop_watch_S2;
                    split_stop_watch_S1 <= stop_watch_S1;
                end
            endcase            end
        end
    end
     always @(posedge clk or posedge rst) begin
        if (rst) begin
            split_mode <=0;
        end
        else if (CS==STOPWATCH_MODE && set_split_button) begin
            split_mode <=1;
        end
        else if (CS==NORMAL_MODE) begin
            split_mode <=0;
        end
        else begin
            split_mode <=split_mode;
        end
     end

    // ------------------------------------------------
    // sequentiional logic for alarm BLOCK
    // ------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alarm_time_H2 <= 4'd0;
            alarm_time_H1 <= 4'd0;
            alarm_time_M2 <= 4'd0;
            alarm_time_M1 <= 4'd0;
        end
    end
    always @(*) begin
        if(alarm_time_H2==time_H2 && alarm_time_H1==time_H1 && alarm_time_M2==time_M2 && alarm_time_M1==time_M1 && min_tick)
            alarm_on<=1;
        else
            alarm_on<=0;
    end
    // ------------------------------------------------
    // Combinational logic for display BLOCK
    // ------------------------------------------------
    always @(*) begin
            case (CS)
                NORMAL_MODE,
                TIME_HOURS_TENS_MODE,
                TIME_HOURS_ONES_MODE,
                TIME_MINUTES_TENS_MODE,
                TIME_MINUTES_ONES_MODE: begin
                    disp_d3 = time_H2;
                    disp_d2 = time_H1;
                    disp_d1 = time_M2;
                    disp_d0 = time_M1;
                end

                ALARM_HOURS_TENS_MODE,
                ALARM_HOURS_ONES_MODE,
                ALARM_MINUTES_TENS_MODE,
                ALARM_MINUTES_ONES_MODE: begin
                    disp_d3 = alarm_time_H2;
                    disp_d2 = alarm_time_H1;
                    disp_d1 = alarm_time_M2;
                    disp_d0 = alarm_time_M1;
                end

                STOPWATCH_MODE: begin
                    if(split_mode)begin
                    disp_d3 = split_stop_watch_M2;
                    disp_d2 = split_stop_watch_M1;
                    disp_d1 = split_stop_watch_S2;
                    disp_d0 = split_stop_watch_S1;
                    end
                    else begin
                    disp_d3 = stop_watch_M2;
                    disp_d2 = stop_watch_M1;
                    disp_d1 = stop_watch_S2;
                    disp_d0 = stop_watch_S1;
                    end

                end
            endcase
    end

    // ------------------------------------------------
    // Combinational logic for state transition BLOCK
    // ------------------------------------------------
    always @(*) begin
        if (mode_button) begin
            case (CS)
                NORMAL_MODE:begin
                    NS = TIME_HOURS_TENS_MODE;
                end
                TIME_HOURS_TENS_MODE:begin
                    NS = TIME_HOURS_ONES_MODE;
                end
                TIME_HOURS_ONES_MODE:begin 
                    NS = TIME_MINUTES_TENS_MODE;
                end
                TIME_MINUTES_TENS_MODE:begin 
                    NS = TIME_MINUTES_ONES_MODE;
                end
                TIME_MINUTES_ONES_MODE:begin
                    NS = ALARM_HOURS_TENS_MODE;
                end
                ALARM_HOURS_TENS_MODE:begin 
                    NS = ALARM_HOURS_ONES_MODE;
                end
                ALARM_HOURS_ONES_MODE:begin
                    NS = ALARM_MINUTES_TENS_MODE;
                end
                ALARM_MINUTES_TENS_MODE:begin
                    NS = ALARM_MINUTES_ONES_MODE;
                end
                ALARM_MINUTES_ONES_MODE:begin
                    NS = STOPWATCH_MODE;
                end
                STOPWATCH_MODE:begin
                     NS = NORMAL_MODE;
                end
            endcase
        end
        else
           NS = CS;
    end
endmodule