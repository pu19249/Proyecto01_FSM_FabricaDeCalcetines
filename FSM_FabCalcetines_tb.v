//FSM para fabricacion de calcetines
//Jonathan Pu. C. 19249
//Electronica Digital 1 Proyecto01
//Seccion 11 lab

//-----------------MODULO TESTBENCH----------------//
module testbench();

//FSM con el modulo donde se cableo toda la maquina
//entradas del modulo
    reg clk, reset;
    reg [2:0]T;
    reg PB;
    reg SH;
    reg SRaltos;
    reg SRbajos;
    reg TE1;
    reg TE2;
    reg SI1;
    reg SI2;

    wire [2:0]SEbajos;
    wire [2:0]Cbajos;
    wire [2:0]SEaltos;
    wire [2:0]Caltos;
    wire Calbajo, Cpolbajo, Cacbajo, Calalto, Cacalto;
    wire [2:0]PACalbajo;
    wire [2:0]PACpolbajo;
    wire [2:0]PACacbajo;
    wire [2:0]PACalalto;
    wire [2:0]PACacalto;
    wire [2:0]LEDalbajo;
    wire [2:0]LEDpolbajo;
    wire [2:0]LEDacbajo;
    wire [2:0]LEDalalto;
    wire [2:0]LEDacalto;

    initial begin
            clk = 0;
            forever #1 clk = ~clk;
        end

    //Llamo al modulo del otro documento
    FSM Calcetines(clk, reset, [2:0]T, PB, SH, SRaltos, SRbajos, TE1, TE2, SI1, SI2,
                   [2:0]SEbajos, [2:0]Cbajos, [2:0]SEaltos, [2:0]Caltos,
                   Calbajo, Cpolbajo, Cacbajo, Calalto, Cacalto,
                   [2:0]PACalbajo, [2:0]PACpolbajo, [2:0]PACacbajo, [2:0]PACalalto, [2:0]PACacalto,
                   [2:0]LEDalbajo, [2:0]LEDpolbajo, [2:0]LEDacbajo, [2:0]LEDalalto, [2:0]LEDacalto);

    reset = 0; //iniciar con todas los clocks en cero
    initial begin
        #1
        $display("\n");
        $display("FSM Prueba de máquina para los calcetines bajos");
        $display("---------------------");
        $monitor("%b %b %b %b %b %b %b %b %b %b %b %b %b | %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b",
                clk, reset, T[2], T[1], T[0], PB, SH, SRaltos, SRbajos, TE1, TE2, SI1, SI2, SEbajos[2], SEbajos[1], SEbajos[0],
                Cbajos[2], Cbajos[1], Cbajos[0], Calbajo, Cpolbajo, Cacbajo, PACalbajo[2], PACalbajo[1], PACalbajo[0],
                PACpolbajo[2, PACpolbajo[1], PACpolbajo[0], PACacbajo[2], PACacbajo[1], PACacbajo[0], LEDalbajo[2], LEDalbajo[1], LEDalbajo[0],
                LEDpolbajo[2], LEDpolbajo[1], LEDpolbajo[0], LEDacbajo[2], LEDacbajo[1], LEDacbajo[0]);
        #1 clk = 0; 
        #1 clk = 1; reset = 0; T[2] = 1; T[1] = 0; T[0] = 1; PB = 0; SH = 1; SRaltos = 0; SRbajos = 1; TE1 = 0; TE2 = 1; SI1 = 0; SI2 = 1;
        #1 clk = 1; reset = 0; T[2] = 0; T[1] = 0; T[0] = 0; PB = 0; SH = 0; SRaltos = 0; SRbajos = 0; TE1 = 0; TE2 = 0; SI1 = 0; SI2 = 0;
        #1 clk = 1; reset = 1; T[2] = 1; T[1] = 1; T[0] = 1; PB = 1; SH = 1; SRaltos = 1; SRbajos = 1; TE1 = 1; TE2 = 1; SI1 = 1; SI2 = 1;
        #1 clk = 1; reset = 0; T[2] = 1; T[1] = 1; T[0] = 0; PB = 0; SH = 1; SRaltos = 1; SRbajos = 0; TE1 = 1; TE2 = 1; SI1 = 0; SI2 = 0;
        #1 clk = 1; reset = 0; T[2] = 1; T[1] = 1; T[0] = 1; PB = 0; SH = 0; SRaltos = 0; SRbajos = 1; TE1 = 1; TE2 = 1; SI1 = 0; SI2 = 0;
        #1 clk = 1; reset = 0; T[2] = 0; T[1] = 0; T[0] = 0; PB = 0; SH = 0; SRaltos = 0; SRbajos = 0; TE1 = 0; TE2 = 0; SI1 = 0; SI2 = 0;
        #1 clk = 1; reset = 0; T[2] = 0; T[1] = 0; T[0] = 1; PB = 0; SH = 0; SRaltos = 0; SRbajos = 1; TE1 = 1; TE2 = 1; SI1 = 1; SI2 = 1; 
    end

    //Fin del codigo
    initial
        #100 $finish;

    //GTK Wave
    initial begin
        $dumpfile("FSM_FabCalcetines_tb.vcd"); //nombre del documento
        $dumpvars(0, testbench); //nombre del modulo de prueba
    end

//fin del modulo
endmodule