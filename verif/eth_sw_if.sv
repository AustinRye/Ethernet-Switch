////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_sw_if
// Description:
// Ethernet Switch Interface
////////////////////////////////////////////////////////////////////////////////

interface eth_sw_if
    (
        logic        clk,
        logic        rstn,
        logic [31:0] i_dataA,
        logic [31:0] i_dataB,
        logic        i_startA,
        logic        i_startB,
        logic        i_endA,
        logic        i_endB,
        logic [31:0] o_dataA,
        logic [31:0] o_dataB,
        logic        o_startA,
        logic        o_startB,
        logic        o_endA,
        logic        o_endB,
        logic        portA_stall,
        logic        portB_stall
    );
  
    default clocking eth_mon_cb @(posedge clk);
		default input #2ns output #2ns;
        input clk;
        input rstn;
        input i_dataA;
        input i_dataB;
        input i_startA;
        input i_startB;
        input i_endA;
        input i_endB;
        input o_dataA;
        input o_dataB;
        input o_startA;
        input o_startB;
        input o_endA;
        input o_endB;
        input portA_stall;
        input portB_stall;
    endclocking: eth_mon_cb
  
    modport monitor_mp (
		clocking eth_mon_cb
    );
          
    clocking eth_drv_cb @(posedge clk);
		default input #2ns output #2ns;
      	input clk;
      	input rstn;
      	output i_dataA;
      	output i_dataB;
      	output i_startA;
      	output i_startB;
        output i_endA;
        output i_endB;
    endclocking: eth_drv_cb
          
    modport driver_mp (
		clocking eth_drv_cb
    );
  
endinterface