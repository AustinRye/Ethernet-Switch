////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_packet_env_pkg
// Description:
// Ethernet Packet Environment Package
////////////////////////////////////////////////////////////////////////////////

package eth_packet_env_pkg;

`define NUMPORTS 2
`define PORTA_ADDR `hABCD
`define PORTB_ADDR `hBEEF

`include "eth_packet.sv"
`include "eth_packet_gen.sv"
`include "eth_packet_drv.sv"
`include "eth_packet_mon.sv"
`include "eth_packet_chk.sv"

class eth_packet_env;
 	
 	string env_name;
  
  	eth_packet_gen packet_gen;
  	eth_packet_drv packet_drv;
  	eth_packet_mon packet_mon;
  	eth_packet_chk packet_chk;
  
  	mailbox mbx_gen_drv;
    mailbox mbx_mon_chk[4];
  
  	virtual interface eth_sw_if eth_sw_vif;
      
    function new(string name, virtual interface eth_sw_if eth_sw_vif);
		this.env_name = name;
      	this.eth_sw_vif = eth_sw_vif;
        mbx_gen_drv = new();
        packet_gen = new(mbx_gen_drv);
        packet_drv = new(mbx_gen_drv, eth_sw_vif);
        for (int i=0; i<4; i++)
          mbx_mon_chk[i] = new();
        packet_mon = new(mbx_mon_chk, eth_sw_vif);
        packet_chk = new(mbx_mon_chk);
    endfunction: new
      
    task run;
        $display("eth_packet_env::run() called"); 
      	fork
            packet_gen.run();
            packet_drv.run();
            packet_mon.run();
            packet_chk.run();
        join
    endtask: run
  
endclass: eth_packet_env

endpackage: eth_packet_env_pkg