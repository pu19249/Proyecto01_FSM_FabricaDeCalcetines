//FSM para fabricacion de calcetines
//Jonathan Pu. C. 19249
//Electronica Digital 1 Proyecto01
//Seccion 11 lab

// ---------------------DECLARACION DE MODULOS------------------//
//Flip flop asincrono
module FFD(input wire clk, reset, D, output reg Q);
    always @(posedge clk or posedge reset) begin
        if(reset==1'b1)
            Q <= 1'b0; //si el reset esta en uno entonces la salida se resetea
        else
            Q <= D; //de lo contrario la salida toma el valor de la entrada
    end
endmodule

//modulo antirebotes para evitar saltos entre estados
module Antirebotes(input wire clk, reset, SIGNAL, output wire OUT);

    wire EF; //entra al FFD
    wire E; //sale del FFD

    assign EF = SIGNAL;
    assign OUT = ~E & SIGNAL;

    //un FFD
    FFD Anti(clk, reset, SIGNAL, OUT);

endmodule

//timer que tarda diez segundos para la maquina de sellado de calcetines bajos
module Timer1(input wire EN, output wire TI1);
    always @ (EN)
        if (EN == 1) begin //cuando el enable esta en 1, se activa el timer1
            TI1 = 0;
            #10
            TI1 = 1; //despues de 10 unidades de tiempo termina
        end
        else
            TI1 = 0;
endmodule

//timer que tarda 18 segundos para la maquina de sellado de calcetines altos
module Timer2(input wire EN, output wire TI2);
    always @(EN)
        if (EN == 1) begin //cuando el Enable esta en 1, se activa el timer2
            TI2 = 0; //comienza a contar en 0
            #18
            TI2 = 1; //despues de 18 unidades de tiempo termina
        end
        else
            TI2 = 0;
endmodule

//timer que tarda 6 segundos para la maquina de hormado 
module Timer3(input wire EN, output wire TI3);
    always @ (EN)
        if (EN == 1) begin //cuando el Enable esta en 1, se activa el timer3
            TI3 = 0; //comienza a contar en 0
            #6
            TI3 = 1; //despues de seis unidades de tiempo termina
        end
        else
            TI3 = 0;
endmodule


//Modulo de la mano tejedora que es la primera en realizar el proceso

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

//maquina selladora para coser y cortar calcetines de tamaño bajo
module SelladoraBajos(input wire clk, reset, [2:0]TH, SR, TI1, output wire [2:0]SE, [1:0]PL, [2:0]C, EN);

    wire EF2, EF1, EF0; //los cables del estado futuro que entran al FFD
    wire E2, E1, E0; //los cables del estado actual que salen del FFD

    //logica del estado futuro
    assign EF2 = (E2 & E1 & E0) | (~E2 & E1 & ~E0 & TI1) | (E2 & ~E1 & ~E0 & ~TI1);
    assign EF1 = (~E2 & E1 & ~E0) | (~E2 & ~E1 & E0 & TI1) | (E2 & E1 & E0 & ~TI1);
    assign EF0 = (~E2 & E1 & ~E0 & TI1) | (E2 & E1 & E0 & ~TI1) | (~E2 & ~E1 & E0 & ~TI1) |
    (~E2 & ~E1 & ~E0 & TH[2] & TH[1] & TH[0] & ~SR) | (~E2 & ~E1 & ~E0 & ~TH[2] & ~TH[1] & TH[0] & ~SR) |
    (~E2 & ~E1 & ~E0 & TH[2] & ~TH[1] & ~TH[0] & ~SR);

    //logica del estado actual
    assign SE[2] = (E2 & ~E1 & ~E0);
    assign SE[1] = (E2 & ~E1 & ~E0);
    assign SE[0] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign PL[1] = 0;
    assign PL[0] = (E2 & ~E1 & ~E0);
    assign C[2] = (E2 & E1 & E0) | (E2 & ~E1 & ~E0);
    assign C[1] = (E2 & E1 & E0) | (E2 & ~E1 & ~E0);
    assign C[0] = (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign EN = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0) | (E2 & ~E1 & ~E0);

    //tres FF
    FFD Bajos2(clk, reset, EF2, E2);
    FFD Bajos1(clk, reset, EF1, E1);
    FFD Bajos0(clk, reset, EF0, E0);
    
endmodule

//maquina para coser y cortar calcetines altos
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


//maquina que recibe el par de calcetines cortados y los horma
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

//contador de cantidad de calcetines bajos de algodon que hay
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

//contador de cantidd de calcetines bajos de polyester que hay
module PolyesterBajos(input wire clk, reset, PH, SR, [2:0]T, [1:0]PLS, output wire [2:0]PAC, [2:0]LED, CO);

    wire EF2, EF1, EF0; //Entrada a FFD
    wire E2, E1, E0; //Salida de FFD

    //Logica del estado futuro
    assign EF2 = (~E2 & E1 & ~E0 & PH & SR & ~T[2] & T[1] & ~T[0] & ~PLS[1] & PLS[0]);
    assign EF1 = (~E2 & ~E1 & E0 & PH & SR & ~T[2] & T[1] & ~T[0] & ~PLS[1] & PLS[0]) |
    (~E2 & E1 & ~E0 & PH & SR & ~T[2] & T[1] & ~T[0] & ~PLS[1] & PLS[0]);
    assign EF0 = (~E2 & ~E0 & PH & SR & ~T[2] & T[1] & ~T[0] & ~PLS[1] & PLS[0]);

    //Logica salida
    assign PAC[2] = 0;
    assign PAC[1] = (E2 & E1 & E0);
    assign PAC[0] = (E2 & E1 & E0);
    assign LED[2] = (E2 & E1 & E0);
    assign LED[1] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign LED[0] = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign CO = (E2 & E1 & E0);

    //tres FFD
    FFD Polbajos2(clk, reset, EF2, E2);
    FFD Polbajos1(clk, reset, EF1, E1);
    FFD Polbajos0(clk, reset, EF0, E0);

endmodule

//contador de cantidad de calcetines bajos acrilicos que hay
module AcrilicosBajos(input wire clk, reset, PH, SR, [2:0]T, [1:0]PLS, output wire [2:0]PAC, [2:0]LED, CO);

    wire EF2, EF1, EF0; //Entrada a FFD
    wire E2, E1, E0; //Salida de FFD

    //Logica del estado futuro
    assign EF2 = (~E2 & E1 & ~E0 & PH & SR & T[2] & ~T[1] & ~T[0] & ~PLS[1] & PLS[0]);
    assign EF1 = (~E2 & ~E1 & E0 & PH & SR & T[2] & ~T[1] & ~T[0] & ~PLS[1] & PLS[0]) |
    (~E2 & E1 & ~E0 & PH & SR & T[2] & ~T[1] & ~T[0] & ~PLS[1] & PLS[0]);
    assign EF0 = (~E2 & ~E0 & PH & SR & T[2] & ~T[1] & ~T[0] & ~PLS[1] & PLS[0]);

    //Logica salida
    assign PAC[2] = 0;
    assign PAC[1] = (E2 & E1 & E0);
    assign PAC[0] = 0;
    assign LED[2] = 0;
    assign LED[1] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign LED[0] = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign CO = (E2 & E1 & E0);

    //tres FFD
    FFD Acbajos2(clk, reset, EF2, E2);
    FFD Acbajos1(clk, reset, EF1, E1);
    FFD Acbajos0(clk, reset, EF0, E0);

endmodule

//contador de cantidad de calcetines altos de algodon que hay
module AlgodonAltos(input wire clk, reset, PH, SR, [2:0]T, [1:0]PLS, output wire [2:0]PAC, [2:0]LED, CO);

    wire EF2, EF1, EF0; //Entrada a FFD
    wire E2, E1, E0; //Salida de FFD

    //Logica del estado futuro
    assign EF2 = (~E2 & E1 & ~E0 & PH & SR & ~T[2] & ~T[1] & T[0] & PLS[1] & ~PLS[0]);
    assign EF1 = (~E2 & ~E1 & E0 & PH & SR & ~T[2] & ~T[1] & T[0] & PLS[1] & ~PLS[0]) |
    (~E2 & E1 & ~E0 & PH & SR & ~T[2] & ~T[1] & T[0] & PLS[1] & ~PLS[0]);
    assign EF0 = (~E2 & ~E0 & PH & SR & ~T[2] & ~T[1] & T[0] & PLS[1] & ~PLS[0]);

    //Logica salida
    assign PAC[2] = 0;
    assign PAC[1] = 0;
    assign PAC[0] = (E2 & E1 & E0);
    assign LED[2] = 0;
    assign LED[1] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign LED[0] = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign CO = (E2 & E1 & E0);

    //tres FFD
    FFD Algalto2(clk, reset, EF2, E2);
    FFD Algalto1(clk, reset, EF1, E1);
    FFD Algalto0(clk, reset, EF0, E0);

endmodule

//contador de cantidad de calcetines altos de acrilico que hay
module AcrilicoAltos(input wire clk, reset, PH, SR, [2:0]T, [1:0]PLS, output wire [2:0]PAC, [2:0]LED, CO);

    wire EF2, EF1, EF0; //Entrada a FFD
    wire E2, E1, E0; //Salida de FFD

    //Logica del estado futuro
    assign EF2 = (~E2 & E1 & ~E0 & PH & SR & T[2] & ~T[1] & ~T[0] & PLS[1] & ~PLS[0]);
    assign EF1 = (~E2 & ~E1 & E0 & PH & SR & T[2] & ~T[1] & ~T[0] & PLS[1] & ~PLS[0]) |
    (~E2 & E1 & ~E0 & PH & SR & T[2] & ~T[1] & ~T[0] & PLS[1] & ~PLS[0]);
    assign EF0 = (~E2 & ~E0 & PH & SR & T[2] & ~T[1] & ~T[0] & PLS[1] & ~PLS[0]);

    //Logica salida
    assign PAC[2] = 0;
    assign PAC[1] = (E2 & E1 & E0);
    assign PAC[0] = (E2 & E1 & E0);
    assign LED[2] = 0;
    assign LED[1] = (E2 & E1 & E0) | (~E2 & E1 & ~E0);
    assign LED[0] = (E2 & E1 & E0) | (~E2 & ~E1 & E0) | (~E2 & E1 & ~E0);
    assign CO = (E2 & E1 & E0);

    //tres FFD
    FFD Acalto2(clk, reset, EF2, E2);
    FFD Acalto1(clk, reset, EF1, E1);
    FFD Acalto0(clk, reset, EF0, E0);

endmodule

//modulo que junta las cajas negras para formar el funcionamiento completo de la fabricacion de calcetines
module FSM(input wire clk, reset, [2:0]T, PB, SH, SRaltos, SRbajos, TE1, TE2, SI1, SI2,
           output wire [2:0]SEbajos, [2:0]Cbajos, [2:0]SEaltos, [2:0]Caltos,
           Calbajo, Cpolbajo, Cacbajo, Calalto, Cacalto, 
           [2:0]PACalbajo, [2:0]PACpolbajo, [2:0]PACacbajo, [2:0]PACalalto, [2:0]PACacalto,
           [2:0]LEDalbajo, [2:0]LEDpolbajo, [2:0]LEDacbajo, [2:0]LEDalalto, [2:0]LEDacalto);

    //declaro los cables que van a ser la interconexion de mis cajas negras
    wire OUTPUTPB, OUTPUTSH, [2:0]TH, EN1, EN2, EN3, TI1, TI2, TI3, PHa, PHb, OUTSI1, OUTSI2, [1:0]PLalto, [1:0]Plbajo; 

    //instancio mi modulo del antirebote para las dos primeras entradas
    Antirebotes Anti_PB(clk, reset, PB, OUTPUTPB);
    Antirebotes Anti_SH(clk, reset, SH, OUTPUTSH);
    //instancio modulo tejedora
    Tejedora Tej(clk, reset, [2:0]T, OUTPUTPB, OUTPUTSH, [2:0]TH);
    //instancio mi modulo de la selladora para calcetines altos
    SelladoraAltos SellAl(clk, reset, [2:0]TH, SRaltos, TI2, [2:0]SEaltos, [1:0]PLalto, [2:0]Caltos, EN2);
    Timer2 Time2(EN2, TI2);
    //instancio modulo de la selladora para calcetines bajos
    SelladoraBajos SellBa(clk, reset, [2:0]TH, SRbajos, TI2, [2:0]SEbajos, [1:0]PLbajo, [2:0]Cbajos, EN1);
    Timer1 Time1(EN1, TI1);
    //maquina de hormado para altos
    Hormado HO(clk, reset, TE1, [1:0]PLalto, [2:0]T, TI3, PHa, EN3);
    Timer3 Time3(EN3, TI3);
    //maquina de hormado para bajos
    Hormado HOB(clk, reset, TE2, [1:0]PLbajo, [2:0]T, TI3, PHb, EN3);
    //tercer antirebote para contadores
    Antirebotes Anti_SI1(clk, reset, SI1, OUTSI1);
    Antirebotes Anti_SI2(clk, reset, SI2, OUTSI2);
    //contador para calcetines bajos de algodon
    AlgodonBajos Albaj(clk, reset, PHb, OUTSI1, [2:0]T, [1:0]PLS, [2:0]PACalbajo, [2:0]LEDalbajo, Calbajo);
    //contador para calcetines bajos de poliester
    PolyesterBajos Polbaj(clk, reset, PHb, OUTSI1, [2:0]T, [1:0]PLS, [2:0]PACpolbajo, [2:0]LEDpolbajo, Cpolbajo);
    //contador para calcetines bajos de acrilico
    AcrilicosBajos Acbaj(clk, reset, PHb, OUTSI1, [2:0]T, [1:0]PLS, [2:0]PACacbajo, [2:0]LEDacbajo, Cacbajo);
    //contador para calcetines altos de algodon
    AlgodonAltos Algalto(clk, reset, PHa, OUTSI2, [2:0]T, [1:0]PLS, [2:0]PACalalto, [2:0]LEDalalto, Calalto);
    //contador para calcetines altos de acrilico
    AcrilicoAltos Acalto(clk, reset, PHa, OUTSI2, [2:0]T, [1:0]PLS, [2:0]PACacalto, [2:0]LEDacalto, Cacalto);

endmodule