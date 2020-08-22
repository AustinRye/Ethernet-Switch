////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: eth_rx
// Description:
// Ethernet Receiver that buffers incoming data into a FIFO queue
////////////////////////////////////////////////////////////////////////////////

module eth_rx
	(
 		input  logic        clk,     // clock
      	input  logic        rstn,    // reset active low
        input  logic [31:0] i_data,  // port input data
      	input  logic        i_start, // start of input packet data
        input  logic        i_end,   // end of input packet data
        output logic [33:0] wr_data, // write data {i_data[31:0], i_start, i_end}
      	output logic        wr_en    // write enable
    );
  
    typedef enum logic {IDLE, RX} rx_states;
    rx_states rx_state;
    rx_states rx_next_state;
                            
    always @(posedge clk or negedge rstn)
    begin
        if (!rstn)
			rx_state <= IDLE;
      	else
			rx_state <= rx_next_state;
    end
  
    always @(rx_state)
    begin
        case(rx_state)
        	IDLE: begin
                if (i_start)
                begin
                    wr_data <= {i_end, i_start, i_data};
                	wr_en <= 1;	
                end
            end
          	RX: begin
                wr_data <= {i_end, i_start, i_data};
                wr_en <= 1;	
            end
          	default: begin
             	wr_data <= 0;
              	wr_en   <= 0;
            end
        endcase
    end

    always @(rx_state)
    begin
        case(rx_state)
            IDLE: begin
                if (i_start)
               		rx_next_state <= RX;
              	else
                  	rx_next_state <= IDLE;
            end
          	RX: begin
                if (i_end)
                    rx_next_state <= IDLE;
                else
                    rx_next_state <= RX;
            end
          	default: begin
             	rx_next_state <= IDLE; 
            end
        endcase
    end

endmodule