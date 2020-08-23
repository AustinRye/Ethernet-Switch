////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_packet_drv
// Description:
// Ethernet Packet Driver
////////////////////////////////////////////////////////////////////////////////

class eth_packet_drv;
  
 	virtual interface eth_sw_if eth_sw_vif;
      
    mailbox mbx;
      
    function new(mailbox mbx, virtual interface eth_sw_if eth_sw_vif);
		this.mbx = mbx;
      	this.eth_sw_vif = eth_sw_vif;
    endfunction: new
      
    task run;
     	eth_packet pkt;
      	forever begin
            mbx.get(pkt); 
            $display("packet_drv::got packet=%s", pkt.to_string());
            if (pkt.src_addr == `PORTA_ADDR)
                drive_pkt_portA(pkt);
            else if (pkt.src_addr == `PORTB_ADDR)
                drive_pkt_portB(pkt);
          	else
              $display("Packets SRC neither A or B. Dropping packet.");
        end
    endtask: run
      
    task drive_pkt_portA(eth_packet pkt);
		int count;
      	int num_dwords;
        bit [31:0] cur_dword;
      	count = 0;
      	num_dwords = pkt.pkt_size_bytes/4;
        $display("packet_drv::drive_pkt_portA: num_dwords=%0d", num_dwords);
        forever @(posedge eth_sw_vif.clk) begin
            if (!eth_sw_vif.portA_stall) begin
				eth_sw_vif.eth_drv_cb.i_startA <= 1'b0;
                eth_sw_vif.eth_drv_cb.i_endA <= 1'b0;
                cur_dword[7:0] = pkt.pkt_full[4*count];
                cur_dword[15:8] = pkt.pkt_full[4*count+1];
                cur_dword[23:16] = pkt.pkt_full[4*count+2];
                cur_dword[31:24] = pkt.pkt_full[4*count+3];
                $display("time=%t packet_drv::drive_pkt_portA:count=%0d cur_dword=%h", $time, count, cur_dword);
                if (count == 0) begin
					eth_sw_vif.eth_drv_cb.i_startA <= 1'b1;
                    eth_sw_vif.eth_drv_cb.i_dataA <= cur_dword;
                    count++;
                end else if (count == num_dwords-1) begin
                    eth_sw_vif.eth_drv_cb.i_endA <= 1'b1; 
                    eth_sw_vif.eth_drv_cb.i_dataA <= cur_dword; 
                  	count++;
                end else if (count == num_dwords) begin
                 	count = 0;
                  	break;
                end else begin
                 	eth_sw_vif.eth_drv_cb.i_dataA <= cur_dword;
                  	count++;
                end
            end
        end
    endtask: drive_pkt_portA
      
    task drive_pkt_portB(eth_packet pkt);
		int count;
      	int num_dwords;
        bit [31:0] cur_dword;
      	count = 0;
      	num_dwords = pkt.pkt_size_bytes/4;
        $display("packet_drv::drive_pkt_portB: num_dwords=%0d", num_dwords);
        forever @(posedge eth_sw_vif.clk) begin
            if (!eth_sw_vif.portB_stall) begin
				eth_sw_vif.eth_drv_cb.i_startB <= 1'b0;
                eth_sw_vif.eth_drv_cb.i_endB <= 1'b0;
                cur_dword[7:0] = pkt.pkt_full[4*count];
                cur_dword[15:8] = pkt.pkt_full[4*count+1];
                cur_dword[23:16] = pkt.pkt_full[4*count+2];
                cur_dword[31:24] = pkt.pkt_full[4*count+3];
                $display("time=%t packet_drv::drive_pkt_portB:count=%0d cur_dword=%h", $time, count, cur_dword);
                if (count == 0) begin
					eth_sw_vif.eth_drv_cb.i_startB <= 1'b1;
                    eth_sw_vif.eth_drv_cb.i_dataB <= cur_dword;
                    count++;
                end else if (count == num_dwords-1) begin
                    eth_sw_vif.eth_drv_cb.i_endB <= 1'b1; 
                    eth_sw_vif.eth_drv_cb.i_dataB <= cur_dword; 
                  	count++;
                end else if (count == num_dwords) begin
                 	count = 0;
                  	break;
                end else begin
                 	eth_sw_vif.eth_drv_cb.i_dataB <= cur_dword;
                  	count++;
                end
            end
        end
    endtask: drive_pkt_portB
      
endclass: eth_packet_drv