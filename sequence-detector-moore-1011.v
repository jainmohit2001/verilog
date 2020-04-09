module moore1011(input clk, input x, output reg y, output reg [2:0]st);
    reg [2:0]state;
    reg [2:0]next_state;
    parameter S0 = 0,S1 = 1, S2 = 2, S3 = 3, S4=4;
    initial begin
        state <= S0;
        st <= S0;
    end

    always@(posedge clk)
    begin
        state <= next_state;
        st <= next_state;
    end

    always@(state or x)
    begin
        y = 0;
        case(state)
        S0: if(x)
                begin
                    next_state = S1;
                end
            else
                next_state = S0;

        S1: if(x)
                next_state = S1;
            else
                next_state = S2;

        S2: if(x)
                next_state = S3;
            else
                next_state = S0;
        S3: if(x)
                    next_state = S4;
            else
                next_state = S2;
        S4: if(x)
                next_state = S1;
            else
                next_state = S2;
        default:
                next_state = S0;
        endcase
    end

    always@(state)
    begin
        case(state)
            S0: y=0;
            S1: y=0;
            S2: y=0;
            S3: y=0;
            S4: y=1;
        endcase
    end
endmodule

module test;
    reg clk,x;
    wire y;
    wire [2:0]st;

    moore1011 uut (.clk(clk),.x(x),.y(y), .st(st));

    always
        begin
            clk = ~clk; #5;
        end
    initial begin
        clk=0;
        x=0;
        #15;
        x=1; #10;
        x = 0; #10;
        x=1; #10;
        x=1; #10;
        x=0; #10;
        x = 1; #10;
        x=1; #10;
        $finish;
    end
    initial begin
        $monitor("clk=%d state = %3d t=%3d x=%d output=%d \n",clk ,st,$time,x,y);
    end

endmodule