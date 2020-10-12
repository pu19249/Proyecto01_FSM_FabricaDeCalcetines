//Flip flop asincrono
module FFD(input wire clk, reset, D, output reg Q);
    always @(posedge clk or posedge reset) begin
        if(reset==1'b1)
            Q <= 1'b0; //si el reset esta en uno entonces la salida se resetea
        else
            Q <= D; //de lo contrario la salida toma el valor de la entrada
    end
endmodule

module Hormado(input wire clk, reset, TE, [1:0]PLS, [2:0]T, TI3, output wire PH, EN);

    wire EF; //estado futuro entra al FFD
    wire E; //estado actual sale del FFD

    //logica de salida
    assign PH = E & TI3;
    assign EN = (TE & ~PLS[1] & PLS[0] & ~T[2] & ~T[1] & T[0]) | (TE & PLS[1] & ~PLS[0] & ~T[2] & ~T[1] & T[0]) |
    (TE & ~PLS[1] & PLS[0] & ~T[2] & T[1] & ~T[0]) | (TE & ~PLS[1] & PLS[0] & T[2] & ~T[1] & ~T[0]) |
    (TE & PLS[1] & ~PLS[0] & T[2] & ~T[1] & ~T[0]);

    //logica del estado futuro
    assign EF = (E & ~TI3) | (~E & TE & ~PLS[1] & PLS[0] & ~T[2] & ~T[1] & T[0]) | (~E & TE & PLS[1] & ~PLS[0] & ~T[2] & ~T[1] & T[0]) |
    (~E & TE & ~PLS[1] & PLS[0] & ~T[2] & T[1] & ~T[0]) | (~E & TE & ~PLS[1] & PLS[0] & T[2] & ~T[1] & ~T[0]) |
    (~E & TE & PLS[1] & ~PLS[0] & T[2] & ~T[1] & ~T[0]);

    //FFD
    FFD Hormado(clk, reset, EF, E);

endmodule