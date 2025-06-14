module PWM (
    input wire clk,
    input wire rst_n,
    input wire [31:0] duty_cycle, // duty cycle final = duty_cycle / period
    input wire [31:0] period, // pwm_freq = clk_freq / period
    output reg pwm_out
);

    reg [31:0] counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            if (counter >= period - 1)
                counter <= 0;
            else
                counter <= counter + 1;

            pwm_out <= (counter < duty_cycle);
        end
    end

endmodule