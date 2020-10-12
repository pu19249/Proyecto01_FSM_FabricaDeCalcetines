//Flip flop asincrono
module FFD(input wire clk, reset, D, output reg Q);
    always @(posedge clk or posedge reset) begin
        if(reset==1'b1)
            Q <= 1'b0; //si el reset esta en uno entonces la salida se resetea
        else
            Q <= D; //de lo contrario la salida toma el valor de la entrada
    end
endmodule

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