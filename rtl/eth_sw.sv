////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_sw
// Description:
// Ethernet Switch
////////////////////////////////////////////////////////////////////////////////

`include "fifo.sv"
`include "eth_rx.sv"
`include "eth_tx.sv"

module eth_sw
	(
        input  logic        clk,              // clock
        input  logic        rstn,             // reset active low
        input  logic [31:0] i_data     [0:1], // Port input data
        input  logic        i_start    [0:1], // Start of input packet data
        input  logic        i_end      [0:1], // End of input packet data
        output logic [31:0] o_data     [0:1], // Port output data
        output logic        o_start    [0:1], // Start of output packet data
        output logic        o_end      [0:1], // End of output packet data
        output logic        port_stall [0:1]  // Port backpressure/stall signal
    );
  
    logic        fifo_wr_en   [0:1]; // fifo write enable
    logic        fifo_rd_en   [0:1]; // fifo read enable
    logic [33:0] fifo_wr_data [0:1]; // fifo write data {i_data[31:0], i_start, i_end}
    logic [33:0] fifo_rd_data [0:1]; // fifo read data {o_data[31:0], o_start, o_end}
    logic        fifo_empty   [0:1]; // fifo empty flag
    logic        fifo_full    [0:1]; // fifo full flag
  
    logic        port_busy    [0:1]; // port busy flag

    fifo #(
        .WIDTH (34),
        .DEPTH (32)
    ) u_fifo0 (
        .clk     (clk),
        .rstn    (rstn),
        .wr_en   (fifo_wr_en[0]),
        .rd_en   (fifo_rd_en[0]),
        .wr_data (fifo_wr_data[0]),
        .rd_data (fifo_rd_data[0]),
        .empty   (fifo_empty[0]),
        .full    (fifo_full[0])
    );
  
    fifo #(
        .WIDTH (34),
        .DEPTH (32)
    ) u_fifo1 (
        .clk     (clk),
        .rstn    (rstn),
        .wr_en   (fifo_wr_en[1]),
        .rd_en   (fifo_rd_en[1]),
        .wr_data (fifo_wr_data[1]),
        .rd_data (fifo_rd_data[1]),
        .empty   (fifo_empty[1]),
        .full    (fifo_full[1])
    );
  
    eth_rx u_eth_rx0 (
        .clk     (clk),
        .rstn    (rstn),
        .i_data  (i_data[0]),
        .i_start (i_start[0]),
        .i_end   (i_end[0]),
        .wr_data (fifo_wr_data[0]),
        .wr_en   (fifo_wr_en[0])
    );
  
    eth_rx u_eth_rx1 (
        .clk     (clk),
        .rstn    (rstn),
        .i_data  (i_data[1]),
        .i_start (i_start[1]),
        .i_end   (i_end[1]),
        .wr_data (fifo_wr_data[1]),
        .wr_en   (fifo_wr_en[1])
    );
  
    eth_tx u_eth_tx (
        .clk       (clk),
        .rstn      (rstn),
        .rd_data   (fifo_rd_data),
        .empty     (fifo_empty),
        .full      (fifo_full),
        .i_port_busy (port_busy),
        .rd_en     (fifo_rd_en),
        .o_data    (o_data),
        .o_start   (o_start),
        .o_end     (o_end),
        .o_port_busy (port_busy)
    );
  
endmodule