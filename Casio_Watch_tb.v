`timescale 1ns/1ps

module Casio_Watch_tb;

    // Inputs
    reg clk;
    reg mode;
    reg reset;
    reg set_split;

    // Outputs
    wire [3:0] screen_H2;
    wire [3:0] screen_H1;
    wire [3:0] screen_M2;
    wire [3:0] screen_M1;
    wire alarm_on;

    //temp values for testing 
    reg [3:0] temp1;
    reg [3:0] temp2;
    reg [3:0] temp3;
    reg [3:0] temp4;
    // Instantiate the DUT
    Casio_Watch dut (
        .clk(clk),
        .mode_button(mode),
        .rst(reset),
        .set_split_button(set_split),
        .disp_d3(screen_H2),
        .disp_d2(screen_H1),
        .disp_d1(screen_M2),
        .disp_d0(screen_M1),
        .alarm_on(alarm_on)
    );
    // Clock generation: 1Hz simulated as 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        reset = 1;
        mode = 0;
        set_split = 0;

        #10;          // wait 1 clock cycles
        reset = 0;    // release reset

        // Let the watch run in NORMAL mode
        #864000;//600 * 60 * 24   00:00->23:59  (TEST 1: Full HH:MM cycle) 
        #42210;//40 * 60 * 17+40*35
        temp1=dut.CS;
        mode = 1;//mode raised for 1 clock cycles NORMAL_MODE mode -> TIME_HOURS_TENS_MODE (TEST 0 :mode change each clock if mode pressed )
        #10;
        mode = 0;
        temp2=dut.CS;
        if(temp1==temp2-1)
            begin
                $display("[PASS] TEST 0: Mode Changed successfully NORMAL_MODE mode -> TIME_HOURS_TENS_MODE");
            end
        else
            begin
                $display("[FAIL] TEST 0: Mode not Changed successfully ");
            end
        temp1=dut.time_H2;
        set_split = 1;//press set in TIME_HOURS_TENS_MODE mode (TEST 2: Change curent time) 
         #10;
        set_split = 0;
        temp2=dut.time_H2;
        if (dut.time_H1 > 4)
            if(temp2 ==(temp1 >= 1) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.time_H1,dut.time_M2,dut.time_M1,temp2,dut.time_H1,dut.time_M2,dut.time_M1);
            else
                $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.time_H1,dut.time_M2,dut.time_M1,temp2,dut.time_H1,dut.time_M2,dut.time_M1);

        else
            if(temp2 ==(temp1 == 2) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.time_H1,dut.time_M2,dut.time_M1,temp2,dut.time_H1,dut.time_M2,dut.time_M1);
            else
               $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.time_H1,dut.time_M2,dut.time_M1,temp2,dut.time_H1,dut.time_M2,dut.time_M1);
        mode = 1;
        #10;
        mode = 0;
        temp1=dut.time_H1;
        set_split = 1;//press set in TIME_HOURS_ONES_MODE mode (TEST 2: Change curent time) 
         #10;
        set_split = 0;
        temp2=dut.time_H1;
        if (dut.time_H2 == 2)
            if(temp2 ==(temp1 == 3) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,temp1,dut.time_M2,dut.time_M1,dut.time_H2,temp2,dut.time_M2,dut.time_M1);
            else
                $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,temp1,dut.time_M2,dut.time_M1,dut.time_H2,temp2,dut.time_M2,dut.time_M1);

        else
            if(temp2 ==(temp1 == 9) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,temp1,dut.time_M2,dut.time_M1,dut.time_H2,temp2,dut.time_M2,dut.time_M1);
            else
               $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,temp1,dut.time_M2,dut.time_M1,dut.time_H2,temp2,dut.time_M2,dut.time_M1);
        mode = 1;
        #10;
        mode = 0;
        temp1=dut.time_M2;
        set_split = 1;//press set in TIME_MINUTES_TENS_MODE mode (TEST 2: Change curent time) 
         #10;
        set_split = 0;
        temp2=dut.time_M2;
        if (dut.time_H2 == 2)
            if(temp2 ==(temp1 == 3) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
            else
                $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);

        else
            if(temp2 ==(temp1 == 9) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
            else
               $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
        temp1=dut.time_M2;
        set_split = 1;//press set in TIME_MINUTES_TENS_MODE mode (TEST 2: Change curent time) 
         #10;
        set_split = 0;
        temp2=dut.time_M2;
        if (dut.time_H2 == 2)
            if(temp2 ==(temp1 == 3) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
            else
                $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);

        else
            if(temp2 ==(temp1 == 9) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
            else
               $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
        temp1=dut.time_M2;
        set_split = 1;//press set in TIME_MINUTES_TENS_MODE mode (TEST 2: Change curent time) 
         #10;
        set_split = 0;
        temp2=dut.time_M2;
        if (dut.time_H2 == 2)
            if(temp2 ==(temp1 == 3) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
            else
                $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);

        else
            if(temp2 ==(temp1 == 9) ? 0 : temp1 + 1)
               $display("[PASS] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
            else
               $display("[FAIL] TEST 2: 1 press Change curent time from %d%d:%d%d to %d%d:%d%d ",dut.time_H2,dut.time_H1,temp1,dut.time_M1,dut.time_H2,dut.time_H1,temp2,dut.time_M1);
        
        mode = 1; //TIME_MINUTES_TENS_MODE mode -> NORMAL mode
        #70;
        mode = 0;
        #20;
        mode = 1;//S_NORMAL mode -> ALARM_HOURS_TENS_MODE
        #50;
        mode = 0;
        temp1=dut.alarm_time_H2;
        set_split = 1;//press set in ALARM_HOURS_TENS_MODE mode (TEST 3: Set alarm time) 
         #10;
        set_split = 0;
        temp2=dut.alarm_time_H2;
        if (dut.alarm_time_H1 > 4)
            if(temp2 ==(temp1 >= 1) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1,temp2,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1);
            else
                $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1,temp2,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1);

        else
            if(temp2 ==(temp1 == 2) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1,temp2,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1);
            else
               $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",temp1,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1,temp2,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1);
        mode = 1;//S_NORMAL mode -> ALARM_HOURS_ONES_MODE
        #10;
        mode = 0;
        temp1=dut.alarm_time_H1;
        set_split = 1;//press set in ALARM_HOURS_ONES_MODE mode (TEST 3: Set alarm time) 
         #10;
        set_split = 0;
        temp2=dut.alarm_time_H1;
        if (dut.alarm_time_H2 == 2)
            if(temp2 ==(temp1  == 3) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
            else
                $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);

        else
            if(temp2 ==(temp1== 9) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
            else
               $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
        #10;
        temp1=dut.alarm_time_H1;
        set_split = 1;//press set in ALARM_HOURS_ONES_MODE mode (TEST 3: Set alarm time) 
         #10;
        set_split = 0;
        temp2=dut.alarm_time_H1;
        if (dut.alarm_time_H2 == 2)
            if(temp2 ==(temp1  == 3) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
            else
                $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);

        else
            if(temp2 ==(temp1== 9) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
            else
               $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
                #10;
        temp1=dut.alarm_time_H1;
        set_split = 1;//press set in ALARM_HOURS_ONES_MODE mode (TEST 3: Set alarm time) 
         #10;
        set_split = 0;
        temp2=dut.alarm_time_H1;
        if (dut.alarm_time_H2 == 2)
            if(temp2 ==(temp1  == 3) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
            else
                $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);

        else
            if(temp2 ==(temp1== 9) ? 0 : temp1 + 1)
               $display("[PASS] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
            else
               $display("[FAIL] TEST 3: 1 press Change alarm time from %d%d:%d%d to %d%d:%d%d ",dut.alarm_time_H2,temp1,dut.alarm_time_M2,dut.alarm_time_M1,dut.alarm_time_H2,temp2,dut.alarm_time_M2,dut.alarm_time_M1);
        mode = 1; //mode raised for 8 clock cycles ALARM_HOURS_ONES_MODE mode -> NORMAL_MODE
        #40;
        mode = 0;
        #10000
        temp1=dut.CS;
        mode = 1; //mode raised for 8 clock cycles NORMAL_MODE mode -> STOPWATCH_MODE
        #90;
        mode = 0;
        temp2=dut.CS;
        if(temp1==temp2-9)
            begin
                $display("[PASS] TEST 0: Mode Changed successfully NORMAL_MODE mode -> STOPWATCH_MODE");
            end
        else
            begin
                $display("[FAIL] TEST 0: Mode not Changed successfully");
            end
        #36000;//10 * 60 * 60   00:00->59:59  (TEST 5: Full MM:SS cycle) 
        #500;
        temp1=dut.stop_watch_M2;
        temp2=dut.stop_watch_M1;
        temp3=dut.stop_watch_S2;
        temp4=dut.stop_watch_S1;
        set_split = 1;//press set in STOPWATCH_MODE mode (TEST 6: split for laps ) 
         #10;
        set_split = 0;
        #120
        if(temp1==screen_H2 && temp2==screen_H1 && temp3==screen_M2 && temp4==screen_M1 &&(temp1!=dut.stop_watch_M2 || temp2!=dut.stop_watch_M1 || temp3!=dut.stop_watch_S2 || temp4!=dut.stop_watch_S1) )
                $display("[PASS] TEST 6: screen time stoped at stop watch time when button pressed and internal timer is working ");
            else
                $display("[FAIL] TEST 6: screen time is changed or internal timer is not working");
        set_split = 1;//press set in STOPWATCH_MODE mode (TEST 6: split for laps ) 
         #10;
        set_split = 0;
        #340;
        temp1=dut.stop_watch_M2;
        temp2=dut.stop_watch_M1;
        temp3=dut.stop_watch_S2;
        temp4=dut.stop_watch_S1;
        set_split = 1;//press set in STOPWATCH_MODE mode (TEST 6: split for laps ) 
         #10;
        set_split = 0;
        #200;
        if(temp1==screen_H2 && temp2==screen_H1 && temp3==screen_M2 && temp4==screen_M1&&(temp1!=dut.stop_watch_M2 || temp2!=dut.stop_watch_M1 || temp3!=dut.stop_watch_S2 || temp4!=dut.stop_watch_S1))
            $display("[PASS] TEST 6: screen time stoped at stop watch time when button pressed and internal timer is working ");
        else
            $display("[FAIL] TEST 6: screen time is changed or internal timer is not working ");
        mode = 1;//mode raised for 1 clock cycles S_STOPWATCH mode -> S_NORMAL
        #10
        mode = 0;
        #500;
        $finish;
    end
    always@(posedge clk)
    begin
        if(dut.time_H2== dut.alarm_time_H2 && dut.time_H1==dut.alarm_time_H1 && dut.time_M2==dut.alarm_time_M2 &&dut.time_M1==dut.alarm_time_M1 && dut.min_tick )
        begin
            if(dut.alarm_on==1)
            begin
                $display("[PASS] TEST 4: Alarm triggered successfully time is:- %d%d:%d%d alarm time is:- %d%d:%d%d ",dut.time_H2,dut.time_H1,dut.time_M2,dut.time_M1,dut.alarm_time_H2,dut.alarm_time_H1,dut.alarm_time_M2,dut.alarm_time_M1);
            end
            else
            begin
                $display("[FAIL] TEST 4: Alarm not triggered");
            end

        end
    end
    always@(posedge clk)
    begin
        if(dut.time_H2== 2 && dut.time_H1==3 && dut.time_M2==5 && dut.time_M1==9 && dut.clk_cnt_nm==0)
        begin
            #600
            if(dut.time_H2== 0 && dut.time_H1==0 &&dut.time_M2==0 && dut.time_M1==0 &&dut.clk_cnt_nm==0)
            begin
                $display("[PASS] TEST 1: Full 24h cycle rollover successful (Time is 00:00)");
            end
            else
            begin
                $display("[FAIL] TEST 1: Expected 00:00, Got %d%d:%d%d ", screen_H2, screen_H1, screen_M2, screen_M1);
            end

        end
    end
    always@(posedge clk)
    begin
        if(dut.stop_watch_M2== 5 && dut.stop_watch_M1==9 && dut.stop_watch_S2==5 &&dut.stop_watch_S1==9 && dut.clk_cnt_swm==0 && dut.CS==dut.STOPWATCH_MODE)
        begin
            #10
            if(dut.stop_watch_M2== 0 && dut.stop_watch_M1==0 && dut.stop_watch_S2==0 && dut.stop_watch_S1==0&& dut.clk_cnt_swm==0)
            begin
                $display("[PASS] TEST 5: Full stop watch cycle rollover successful (Time is 00:00)");
            end
            else
            begin
                $display("[FAIL] TEST 5: Expected 00:00, Got %d%d:%d%d", dut.stop_watch_M2, dut.stop_watch_M1,dut.stop_watch_S2, dut.stop_watch_S1);
            end

        end
    end
endmodule
