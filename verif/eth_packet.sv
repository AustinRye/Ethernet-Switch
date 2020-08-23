////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_packet
// Description:
// Ethernet Packet
////////////////////////////////////////////////////////////////////////////////

class eth_packet;
 
    rand bit  [31:0] src_addr;
    rand bit  [31:0] dst_addr;
    rand byte        pkt_data [];
    bit       [31:0] pkt_crc;
  
  	int pkt_size_bytes;
    byte pkt_full [];
  
    constraint addr_con {
        src_addr inside {'hABCD, 'hBEEF};
        dst_addr inside {'hABCD, 'hBEEF};
    }
  
    constraint pkt_data_con {
      pkt_data.size() >= 4;
      pkt_data.size() <= 32;
      pkt_data.size()%4 == 0;
    }
  
    function new();
    endfunction: new
  
    function bit [31:0] compute_crc();
		return 'hABCDDEAD;
    endfunction: compute_crc
  
    function string to_string();
		string msg;
        msg = $psprintf("SA=%x DA=%x CRC=%x", src_addr, dst_addr, pkt_crc);
        return msg;
    endfunction: to_string
  
    function bit compare_pkt(eth_packet pkt);
        if ((this.src_addr == pkt.src_addr) &&
            (this.dst_addr == pkt.dst_addr) &&
            (this.pkt_data == pkt.pkt_data) &&
            (this.pkt_crc == pkt.pkt_crc))
            return 1'b1;
        else
            return 1'b0;
    endfunction: compare_pkt
  
endclass