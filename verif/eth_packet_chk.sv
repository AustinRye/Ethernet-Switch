////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_packet_chk
// Description:
// Ethernet Packet Checker
////////////////////////////////////////////////////////////////////////////////

class eth_packet_chk;
 	
    mailbox mbx[4];
  
    eth_packet exp_pktA_q [];
    eth_packet exp_pktB_q [];
  
    function new(mailbox mbx[4]);
        for (int i=0; i<4; i++) begin
            this.mbx[i] = mbx[i];
        end
    endfunction: new
  
  	task run;
        $display("packet_chk::run() called");
        fork
            get_and_process_pkt(0);
            get_and_process_pkt(1);
            get_and_process_pkt(2);
            get_and_process_pkt(3);
        join_none
    endtask: run
  
    task get_and_process_pkt(int port);
		eth_packet pkt;
        $display("packet_chk::process_pkt on port=%0d called", port);
      	forever begin
            mbx[port].get(pkt);
            $display("time=%0t packet_chk::got packet on port=%0d packet=%s", $time, port, pkt.to_string());
            if (port < 2)
                gen_exp_packet_q(pkt);
            else
                chk_exp_packet_q(port, pkt);
        end
    endtask: get_and_process_pkt
  
    function void gen_exp_packet_q(eth_packet pkt);
        if (pkt.dst_addr == `PORTA_ADDR)
            exp_pktA_q.push_back(pkt); 
        else if (pkt.dst_addr == `PORTB_ADDR)
            exp_pktB_q.push_back(pkt); 
      	else
            $error("Illegal Packet received");
    endfunction: gen_exp_packet_q
  
    function void chk_exp_packet_q(int port, eth_packet pkt);
		eth_packet exp;
        if (port == 2)
            exp = exp_pktA_q.pop_front();
        else if (port == 3)
            exp = exp_pktB_q.pop_front(); 
        if (pkt.compare_pkt(exp))
            $display("Packet on port 2 (output A) matches");
      	else
            $display("Packet on port 2 (output A) mismatches");
    endfunction: chk_exp_packet_q
  
endclass: eth_packet_chk