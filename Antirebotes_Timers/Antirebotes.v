//Flip flop asincrono
module FFD(input wire clk, reset, D, output reg Q);
    always @(posedge clk or posedge reset) begin
        if(reset==1'b1)
            Q <= 1'b0; //si el reset esta en uno entonces la salida se resetea
        else
            Q <= D; //de lo contrario la salida toma el valor de la entrada
    end
endmodule

module Antirebotes(input wire clk, reset, SIGNAL, output wire OUT);

    wire EF; //entra al FFD
    wire E; //sale del FFD

    assign EF = SIGNAL;
    assign OUT = ~E & SIGNAL;

    //un FFD
    FFD Anti(clk, reset, SIGNAL, OUT);

endmodule