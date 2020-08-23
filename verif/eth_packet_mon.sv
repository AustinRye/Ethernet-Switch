////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_packet_mon
// Description:
// Ethernet Packet Monitor
////////////////////////////////////////////////////////////////////////////////

class eth_packet_mon;
  
  	virtual interface eth_sw_if eth_sw_vif;
      
    mailbox mbx[4];
      
    function new(mailbox mbx[4], virtual interface eth_sw_if eth_sw_vif);
		this.mbx = mbx;
      	this.eth_sw_vif = eth_sw_vif;
    endfunction: new
      
    task run;
     	fork
            sample_portA_input_pkt();
            sample_portA_output_pkt();
            sample_portB_input_pkt();
            sample_portB_output_pkt();
        join
    endtask: run
      
    task sample_portA_input_pkt();
		eth_packet pkt;
      	int count;
      	count = 0;
        forever @(posedge eth_sw_vif.clk) begin
            if (eth_sw_vif.eth_mon_cb.i_startA) begin
                $display("time=%t packet_mon::seeing Start on Port A input", $time);
                pkt = new();
                pkt.dst_addr = eth_sw_vif.eth_mon_cb.i_dataA;
                count++;
            end else if (count == 1) begin
             	pkt.src_addr = eth_sw_vif.eth_mon_cb.i_dataA;
                count++;
            end else if (eth_sw_vif.eth_mon_cb.i_endA) begin
             	pkt.pkt_crc = eth_sw_vif.eth_mon_cb.i_dataA;
                $display("time=%0t packet_mon: Saw packet on Port A input: pkt=%s", $time, pkt.to_string());
                mbx[0].put(pkt);
                count = 0;
            end else if (count > 0) begin
                pkt.pkt_data.push_back(eth_sw_vif.eth_mon_cb.i_dataA); 
                count++;
            end
        end
    endtask: sample_portA_input_pkt
      
    task sample_portA_output_pkt();
		eth_packet pkt;
      	int count;
      	count = 0;
        forever @(posedge eth_sw_vif.clk) begin
          if (eth_sw_vif.eth_mon_cb.o_startA) begin
              $display("time=%t packet_mon::seeing Start on Port A output", $time);
                pkt = new();
                pkt.dst_addr = eth_sw_vif.eth_mon_cb.o_dataA;
                count++;
            end else if (count == 1) begin
             	pkt.src_addr = eth_sw_vif.eth_mon_cb.o_dataA;
                count++;
            end else if (eth_sw_vif.eth_mon_cb.o_endA) begin
             	pkt.pkt_crc = eth_sw_vif.eth_mon_cb.o_dataA;
                $display("time=%0t packet_mon: Saw packet on Port A output: pkt=%s", $time, pkt.to_string());
                mbx[0].put(pkt);
                count = 0;
            end else if (count > 0) begin
                pkt.pkt_data.push_back(eth_sw_vif.eth_mon_cb.o_dataA); 
                count++;
            end
        end
    endtask: sample_portA_output_pkt
      
    task sample_portB_input_pkt();
		eth_packet pkt;
      	int count;
      	count = 0;
        forever @(posedge eth_sw_vif.clk) begin
            if (eth_sw_vif.eth_mon_cb.i_startB) begin
                $display("time=%t packet_mon::seeing Start on Port B input", $time);
                pkt = new();
                pkt.dst_addr = eth_sw_vif.eth_mon_cb.i_dataB;
                count++;
            end else if (count == 1) begin
             	pkt.src_addr = eth_sw_vif.eth_mon_cb.i_dataB;
                count++;
            end else if (eth_sw_vif.eth_mon_cb.i_endB) begin
             	pkt.pkt_crc = eth_sw_vif.eth_mon_cb.i_dataB;
                $display("time=%0t packet_mon: Saw packet on Port B input: pkt=%s", $time, pkt.to_string());
                mbx[0].put(pkt);
                count = 0;
            end else if (count > 0) begin
                pkt.pkt_data.push_back(eth_sw_vif.eth_mon_cb.i_dataB); 
                count++;
            end
        end
    endtask: sample_portB_input_pkt
      
    task sample_portB_output_pkt();
		eth_packet pkt;
      	int count;
      	count = 0;
        forever @(posedge eth_sw_vif.clk) begin
            if (eth_sw_vif.eth_mon_cb.o_startB) begin
                $display("time=%t packet_mon::seeing Start on Port B output", $time);
                pkt = new();
                pkt.dst_addr = eth_sw_vif.eth_mon_cb.o_dataB;
                count++;
            end else if (count == 1) begin
             	pkt.src_addr = eth_sw_vif.eth_mon_cb.o_dataB;
                count++;
            end else if (eth_sw_vif.eth_mon_cb.o_endB) begin
             	pkt.pkt_crc = eth_sw_vif.eth_mon_cb.o_dataB;
                $display("time=%0t packet_mon: Saw packet on Port B output: pkt=%s", $time, pkt.to_string());
                mbx[0].put(pkt);
                count = 0;
            end else if (count > 0) begin
                pkt.pkt_data.push_back(eth_sw_vif.eth_mon_cb.o_dataB); 
                count++;
            end
        end
    endtask: sample_portB_output_pkt
  
endclass: eth_packet_mon