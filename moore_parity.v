module moore(input clk, input x, output reg parity);
    reg state, nextstate;
    parameter S0=0, S1=1;
initial begin
    state<= S0;
end
always @(posedge clk) // always block to update state
    state <= nextstate;

always @(state) // always block to compute output
begin
     case(state)
         S0: parity = 0;
         S1: parity = 1;
     endcase
end

always @(state or x) // always block to compute nextstate
begin
     nextstate = S0;
     case(state)
         S0: if(x)
                 nextstate = S1;
         S1: if(!x)
                 nextstate = S1;
     endcase
end

endmodule

module test;
    reg clk,x;
    wire parity;

    moore uut (.clk(clk),.x(x),.parity(parity));

    always
        begin
            clk = ~clk; #5;
        end
    initial begin
        clk=0;
        x=0;
        #15;
        x = 1; #10;
        x=0; #10;
        x=1; #10;
        x=0; #10;
        x = 1; #10;
        x=0; #10;
        $finish;
    end
    initial begin
        $monitor("clk=%d t=%3d x=%d parity=%d \n",clk ,$time,x,parity);
    end

endmodule