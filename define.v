//instruction define
`define	HALT	4'h0
`define NOP	4'h1
`define CMOVXX	4'h2
`define IRMOVQ	4'h3
`define	RMMOVQ	4'h4
`define MRMOVQ	4'h5
`define OPQ	4'h6
`define JXX	4'h7
`define CALL	4'h8
`define RET	4'h9
`define PUSHQ	4'hA
`define	POPQ	4'hB
//condition define
`define C_YES	4'h0
`define C_LE	4'h1
`define C_L	4'h1
`define C_E	4'h3
`define C_NE	4'h4
`define C_GE	4'h5
`define C_G	4'h6
//ALU define
`define ALUADD	4'h0
`define ALUSUB	4'h1
`define ALUAND	4'h2
`define ALUXOR 	4'h3