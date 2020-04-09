module mealy(input clk ,input x, output reg parity, output reg st);
	reg state, nextstate;
	parameter S0=0, S1=1;
initial begin
    state <= S0;
    st <= S0;
end
always @(posedge clk) //always block to update state
begin
    state <= nextstate;
    st <= nextstate;
end

always @(state or x) // always block to compute both ouput and nextstate
begin
	parity = 1'b0;
	case(state)
		S0: if(x)
				begin
					parity = 1; nextstate = S1;
				end
			else
				nextstate = S0;
		S1: if(x)
				nextstate = S0;
			else
				begin
					parity = 1; nextstate = S1;
				end
		default:
			nextstate = S0;
	endcase
end
endmodule

module test;
    reg clk,x;
    wire parity, st;

    mealy uut (.clk(clk),.x(x),.parity(parity), .st(st));

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
        $monitor("clk=%d state = %d t=%3d x=%d parity=%d \n",clk ,st,$time,x,parity);
    end

endmodule