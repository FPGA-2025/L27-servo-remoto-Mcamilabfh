module servo #(
    parameter CLK_FREQ = 25_000_000, // 25 MHz
    parameter PERIOD = 500_000 // 50 Hz (1/50s = 20ms, 25MHz / 50Hz = 500000 cycles)
) (
    input wire clk,
    input wire rst_n,
    output wire servo_out
);

 // Largura dos pulsos (1 ms a 2 ms)
    localparam integer DUTY_MIN = PERIOD * 5 / 100;   // 5% do período
    localparam integer DUTY_MAX = PERIOD * 10 / 100;  // 10% do período



    // Tempo de espera em cada posição (5 segundos)
    localparam integer WAIT_TIME = CLK_FREQ * 5;   // 125_000_000

    // Sinais internos
    reg [31:0] duty_cycle;
    reg        dir;              // Direção: 1 = máximo, 0 = mínimo
    reg [31:0] wait_counter;


    // PWM output wire
    wire pwm_out;

    // Alterna entre mínimo e máximo a cada 5 segundos
    always @(posedge clk) begin
        if (!rst_n) begin
            duty_cycle   <= DUTY_MIN;
            dir          <= 1'b1;
            wait_counter <= 0;
        end else begin
            if (wait_counter >= WAIT_TIME) begin
                wait_counter <= 0;

                if (dir)
                    duty_cycle <= DUTY_MAX;
                else
                    duty_cycle <= DUTY_MIN;

                dir <= ~dir;
            end else begin
                wait_counter <= wait_counter + 1;
            end
        end
    end

    // Instancia o PWM
    PWM pwm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle),
        .period(PERIOD),
        .pwm_out(pwm_out)
    );

    assign servo_out = pwm_out;

endmodule
