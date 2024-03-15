module my421mux (s1, s0, u, v ,w, x, m);
	input s0, s1;
	input [3:0] u, v, w, x;
	output [3:0] m;
	
	wire [3:0] wire1, wire2;
	introlab my1(.X(u), .Y(v), .S(s0), .M(wire1));
	introlab my2(.X(w), .Y(x), .S(s0), .M(wire2));
	introlab my3(.X(wire1), .Y(wire2), .S(s1), .M(m));
endmodule
