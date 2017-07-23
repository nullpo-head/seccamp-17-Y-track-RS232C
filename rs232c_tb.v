

`timescale 1 ns/ 1 ns
module rs232c_tb ();

parameter clock = 50_000_000;
parameter baudrate = 9600;
parameter wait_time = clock / baudrate;

reg clk = 1'b0;
reg rst_n = 1'b1;
wire tx;

reg rs232c_unit = 1'b0;
integer wait_count = 0;

rs232c top (
    .clk (clk),
    .rst_n (rst_n),
    .tx (tx)
);

initial
begin

$display("Running testbench");
forever #20 clk = !clk; 

end

always @(posedge clk) begin
    if (wait_count == wait_time)  begin
        rs232c_unit <= !rs232c_unit;
        wait_count <= 0;
    end
    else
        wait_count <= wait_count + 1;
end

always begin
    #(20 * wait_time * 4 + wait_time / 3) rst_n = 0;
    #(20 * wait_time * 15) rst_n = 1;
end

endmodule

