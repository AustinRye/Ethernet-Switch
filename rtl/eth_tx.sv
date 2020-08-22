////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_tx
// Description:
// Ethernet Transmitter that sends out data from the FIFO queue
////////////////////////////////////////////////////////////////////////////////

module eth_tx
    #(
      parameter [31:0] PORT_ADDR [0:1] = {0, 0}
    ) (
 		input  logic        clk,               // clock
      	input  logic        rstn,              // reset active low
        input  logic [33:0] rd_data     [0:1], // port input data
        input  logic        empty       [0:1], // queue empty flag
      	input  logic        full        [0:1], // queue full flag
        input  logic        i_port_busy [0:1], // port busy flag
      	output logic        rd_en       [0:1], // start of input packet data
        output logic [31:0] o_data      [0:1], // end of input packet data
        output logic        o_start     [0:1], // write data {i_data[31:0], i_start, i_end}
        output logic        o_end       [0:1], // write enable
        output logic        o_port_busy [0:1], // port busy flag
        output logic 		port_stall  [0:1]  // port backpressure/stall signal
    );
  
    typedef enum logic [1:0] {IDLE, DEST_ADDR, TX} tx_states;
    tx_states tx_state [0:1];
    tx_states tx_next_state [0:1];
  
    logic        dest_port [0:1];
  
    logic [31:0] i_data  [0:1];
    logic        i_start [0:1];
    logic        i_end   [0:1];
  
  	integer i;
  	
  	generate
    for (genvar i=0; i<=1; i++)
    begin
  
        assign i_data[i]  = rd_data[i][31:0];
        assign i_start[i] = rd_data[i][32];
        assign i_end[i]   = rd_data[i][33];

        always @(posedge clk or negedge rstn)
        begin
            if (!rstn)
                tx_state[i] <= IDLE;
            else
                tx_state[i] <= tx_next_state[i];
        end

        always @(tx_state[i])
        begin
            case(tx_state[i])
                IDLE: begin
                    if (~empty[i])
                        rd_en[i] <= 1;
                end
                DEST_ADDR: begin
                    if (i_start[i])
                    begin
                        for (int i=0; i<=1; i++)
                        begin
                            if (i_data[i] == PORT_ADDR[i])
                                dest_port[i] = i;
                        end
                        if (i_port_busy[dest_port[i]])
                            rd_en[i] <= 0;
                        else
                        begin
                            o_port_busy[dest_port[i]] <= 1;	
                            rd_en[i] <= 1;
                        end
                    end
                end
                TX: begin
                    if (i_end[i])
                    begin
                        o_port_busy[dest_port[i]] <= 0;
                        rd_en[i] <= 0;
                    end
                end
                default: begin
                    dest_port[i] <= 0;
                end
            endcase
        end

        always @(tx_state[i])
        begin
            case(tx_state[i])
                IDLE: begin
                  if (~empty[i])
                        tx_next_state[i] <= DEST_ADDR;
                    else
                        tx_next_state[i] <= IDLE;
                end
                DEST_ADDR: begin
                    if (i_start[i])
                      if (i_port_busy[dest_port[i]])
                            tx_next_state[i] <= DEST_ADDR;
                        else
                        begin
                            tx_next_state[i] <= TX;
                        end
                    else
                        tx_next_state[i] <= DEST_ADDR; 
                end
                TX: begin
                    if (i_end[i])
                        tx_next_state[i] <= IDLE;
                    else
                        tx_next_state[i] <= TX;
                end
                default: begin
                    tx_next_state[i] <= IDLE; 
                end
            endcase
        end
      
        always @(posedge clk)
        begin
            if (!rstn)  
                port_stall[i] <= 0;
          	else
                port_stall[i] <= full[i];
        end
      
    end
    endgenerate

endmodule