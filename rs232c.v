module rs232c (
    input clk,
    output tx,
    input rst_n
);

parameter message = "Hello, World!\r\n",
          message_len = 15;

reg go = 1'b0,
    go_next = 1'b0;
reg [8 * message_len - 1 : 0] mes_buf = message,
                          mes_buf_next = message;

wire [7:0] data;
wire ready;

uart_sender #(.baudrate(9600))
sender (
    .clk (clk),
    .go (go),
    .data (data),
    .tx (tx),
    .ready(ready)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        go <= 0;
        mes_buf <= message;
    end
    else begin
        go <= go_next;
        mes_buf <= mes_buf_next;
    end
end

always @(*) begin
    mes_buf_next = mes_buf;
    if (ready && !go) begin
        go_next = 1;
        mes_buf_next = {mes_buf[8 * message_len - 9 : 0], mes_buf[8 * message_len - 1 : 8 * message_len - 8]};
    end
    else begin
        go_next = 0;
    end
end

assign data = mes_buf[8 * message_len - 1: 8 * message_len - 8];

endmodule
