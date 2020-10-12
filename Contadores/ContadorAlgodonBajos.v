//Flip flop asincrono
module FFD(input wire clk, reset, D, output reg Q);
    always @(posedge clk or posedge reset) begin
        if(reset==1'b1)
            Q <= 1'b0; //si el reset esta en uno entonces la salida se resetea
        else
            Q <= D; //de lo contrario la salida toma el valor de la entrada
    end
endmodule

module AlgodonBajos(input wire clk, reset, PH, SR, [2:0]T, [1:0]PLS, output wire [2:0]PAC, [2:0]LED, CO);

    wire EF2, EF1, EF0; //Entrada a FFD
    wire E2, E1, E0; //Salida de FFD

    //Logica del estado futuro
    assign EF2 = (~E2 & E1 & ~E0 & PH & SR & ~T[2] & ~T[1] & T[0] & ~PLS[1] & PLS[0]);
    assign EF1 = (~E2 & ~E1 & E0 & PH & SR & ~T[2] & ~T[1] & T[0] & ~PLS[1] & PLS[0]) |
    (~E2 & E1 & ~E0 & PH & SR & ~T[2] & ~T[1] & T[0] & ~PLS[1] & PLS[0]);
    assign EF0 = (~E2 & ~E0 & PH & SR & ~T[2] & ~T[1] & T[0] & ~PLS[1] & PLS[0]);

    //Logica salida
    assign PAC[2] = 0;
    assign PAC[1] = 0;
    assign PAC[0] = (E2 & E1 & E0);
    assign LED[2] = (E2 & E1 & E0);
    assign LED[1] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign LED[0] = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign CO = (E2 & E1 & E0);

    //tres FFD
    FFD Albajos2(clk, reset, EF2, E2);
    FFD Albajos1(clk, reset, EF1, E1);
    FFD Albajos0(clk, reset, EF0, E0);

endmodule