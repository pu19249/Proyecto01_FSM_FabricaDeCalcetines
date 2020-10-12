//Flip flop asincrono
module FFD(input wire clk, reset, D, output reg Q);
    always @(posedge clk or posedge reset) begin
        if(reset==1'b1)
            Q <= 1'b0; //si el reset esta en uno entonces la salida se resetea
        else
            Q <= D; //de lo contrario la salida toma el valor de la entrada
    end
endmodule

module Tejedora(input wire clk, reset, [2:0]T, PB, SH, output wire [2:0]TH);

    wire EF2, EF1, EF0; //los cables del estado futuro que entran al FFD
    wire E2, E1, E0; //los cables del estado actual salen del FFD
    
    //logica del estado futuro
    assign EF2 = (~E2 & ~E1 & ~E0 & ~T[2] & T[1] & ~T[0] & SH) | (~E2 & ~E1 ~E0 & T[2] & ~T[1] & ~T[0] & SH);
    assign EF1 = (~E2 & ~E1 & ~E0 & ~T[2] & T[1] & ~T[0] & SH) | (~E2 & ~E1 & ~E0 & ~T[2] & ~T[1] & ~T[0] & PB & SH);
    assign EF2 = (~E2 & ~E1 & ~E0 & ~T[2] & T[1] & ~T[0] & SH) | (~E2 & ~E1 & ~E0 & T[2] & ~T[1] & ~T[0] & PB & SH) | (~E2 & ~E1 & ~E0 & ~T[2] & ~T[1] & T[0] & ~PB & SH);

    //ecuaciones de la tabla de salidas (estado actual)
    assign TH[2] = (E2 & ~E1) | (E2 & E0);
    assign TH[1] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign TH[0] = (E2 & E0) | (~E1 & E0);

    //instancio tres FFD que usa la maquina para cada bit de estado
    FFD Tejedora2(clk, reset, EF2, E2);
    FFD Tejedora1(clk, reset, EF1, E1);
    FFD Tejedora0(clk, reset, EF0, E0);

endmodule