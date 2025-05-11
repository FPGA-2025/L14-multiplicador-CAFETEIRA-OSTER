module Multiplier #(
    parameter N = 4
) (
    input wire clk,
    input wire rst_n,

    input wire start,
    output reg ready,

    input wire   [N-1:0] multiplier,
    input wire   [N-1:0] multiplicand,
    output reg [2*N-1:0] product
);
    reg [2*N-1:0] acumulador = 0;
    reg [N-1:0] multiplier_reg;  
    reg [N-1:0] multiplicand_reg; 
    reg status = 0;

    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            ready <= 0;
            acumulador <= 0;
            multiplier_reg <= 0;
            multiplicand_reg <= 0;
            product <= 0;
            status <= 0;
        end else begin
            if (start && !status) begin
                // Inicia a multiplicação
                status <= 1;
                ready <= 0;
                acumulador <= 0;
                multiplier_reg <= multiplier;
                multiplicand_reg <= multiplicand;
            end else if (status) begin
                // Executa a multiplicação
                if (multiplier_reg[0] == 1) begin
                    acumulador <= acumulador + multiplicand_reg;
                end
                    multiplier_reg <= multiplier_reg >> 1; // Desloca para a direita
                    multiplicand_reg <= multiplicand_reg << 1; // Desloca para a esquerda
                if (multiplier_reg == 0) begin
                    // Finaliza a multiplicação
                    product <= acumulador;
                    status <= 0;
                    ready <= 1;
                end
            end
        end
    end
endmodule
