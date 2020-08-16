////////////////////////////////////////////////////////////////////////////////
// Author: Austin Rye <ryeaustinw@gmail.com>
//
// Name: fifo
// Description:
// First In/First Out data structure
////////////////////////////////////////////////////////////////////////////////

module fifo
    #(
        parameter WIDTH = 8,
        parameter DEPTH = 8
    ) (
        input  logic clk,   // clock
        input  logic rstn,  // reset active low
        input  logic wr_en, // write enable
        input  logic rd_en, // read enable
        input  logic [WIDTH-1:0] data_in,  // data in
        output logic [WIDTH-1:0] data_out, // data out
        output logic empty, // empty flag
        output logic full   // full flag
    );

    logic [WIDTH-1:0] mem [0:DEPTH-1];  // memory
    logic [$clog2(DEPTH-1):0] wr_ptr; // write pointer
    logic [$clog2(DEPTH-1):0] rd_ptr; // read pointer
    
    always_ff @(posedge clk or negedge rstn)
        if (!rstn)
        begin
            data_out <= 0;
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            empty    <= 1;
            full     <= 0;
        end
        else
        begin
            if (wr_en & !full)
            begin
                mem[wr_ptr] <= data_in;
                empty <= 0;
                wr_ptr = (wr_ptr + 1) % DEPTH;
                if (wr_ptr == rd_ptr)
                    full <= 1;
            end
            if (rd_en & !empty)
            begin
                data_out <= mem[rd_ptr];
                full <= 0;
                rd_ptr = (rd_ptr + 1) % DEPTH;
                if (wr_ptr == rd_ptr)
                    empty <= 1;
            end
        end

endmodule