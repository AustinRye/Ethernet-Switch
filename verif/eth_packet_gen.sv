////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_packet_gen
// Description:
// Ethernet Packet Generator
////////////////////////////////////////////////////////////////////////////////

class eth_packet_gen;
  
  	int num_pkts;
  
  	mailbox mbx;
  
    function new(mailbox mbx); 
		this.mbx = mbx;
    endfunction: new
  
  	task run;
     	eth_packet pkt;
      	num_pkts = 2;
        for (int i=0; i<num_pkts; i++) begin
            pkt = new();
            assert(pkt.randomize());
            mbx.put(pkt);
        end
    endtask: run
  
endclass: eth_packet_gen