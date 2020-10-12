//Flip flop asincrono
module FFD(input wire clk, reset, D, output reg Q);
    always @(posedge clk or posedge reset) begin
        if(reset==1'b1)
            Q <= 1'b0; //si el reset esta en uno entonces la salida se resetea
        else
            Q <= D; //de lo contrario la salida toma el valor de la entrada
    end
endmodule

module SelladoraAltos(input wire clk, reset, [2:0]TH, SR, TI2, output wire [2:0]SE, [1:0]PL, [2:0]C, EN);

    wire EF2, EF1, EF0; //entradas al FFD
    wire E2, E1, E0; //salidas del FFD

    //logica del estado futuro
    assign EF2 = (E2 & E1 & E0) | (~E2 & E1 & ~E0 & TI2) | (E2 & ~E1 & ~E0 & ~TI2);
    assign EF1 = (~E2 & E1 & ~E0) | (~E2 & ~E1 & E0 & TI2) | (E2 & E1 & E0 & ~TI2);
    assign EF0 = (~E2 & E1 & ~E0 & TI2) | (E2 & E1 & E0 & ~TI2) | (~E2 & ~E1 & E0 & ~TI2) |
    (~E2 & ~E1 & ~E0 & TH[2] & ~TH[1] & TH[0] & ~SR) | (~E2 & ~E1 & ~E0 & ~TH[2] & TH1[1] & ~TH[0] & ~SR);

    //logica del estado actual
    assign SE[2] = (E2 & E1 & E0) | (~E2 & E1 & ~E0) | (E2 & ~E1 & ~E0);
    assign SE[1] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign SE[0] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign PL[1] = (E2 & ~E1 & ~E0);
    assign PL[0] = 0;
    assign C[2] = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0) | (E2 & ~E1 & ~E0);
    assign C[1] = (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign C[0] = (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign EN = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0) | (E2 & ~E1 & ~E0);

    //tres FFD
    FFD Altos2(clk, reset, EF2, E2);
    FFD Altos1(clk, reset, EF1, E1);
    FFD Altos0(clk, reset, EF0, E0);

endmodule