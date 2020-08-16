////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_sw
// Description:
// 2x2 Ethernet Switch
////////////////////////////////////////////////////////////////////////////////

module eth_sw
	(
        input  logic        clk,           // clock
        input  logic        rstn,          // reset active low
        input  logic [31:0] i_data  [0:1], // Port input data
        input  logic        i_start [0:1], // Start of input packet data
        input  logic        i_end   [0:1], // End of input packet data
        output logic [31:0] o_data  [0:1], // Port output data
        output logic        o_start [0:1], // Start of output packet data
        output logic        o_end   [0:1], // End of output packet data
        output logic        stall   [0:1]  // Port backpressure/stall signal
    );

  	

endmodule