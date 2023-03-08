
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;
 
ENTITY tb_ProjetoFinal IS
END tb_ProjetoFinal;
 
ARCHITECTURE behavior OF tb_ProjetoFinal IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
component ProjetoFinal 
	port
	(
		clk		       : in	 std_logic;
		Produto	       : in	 integer;
		botao_cartao    : in	 std_logic;
		botao_dinheiro  : in	 std_logic;
		Pagamento_cartao: in	 std_logic;
		Valor_cartao    : out std_logic_vector (4 downto 0);
		Money_in        : in  std_logic_vector (4 downto 0);
		Money_out       : out std_logic_vector (4 downto 0);
		reset	          : in	 std_logic;
		saida_dispenser : out integer;
		cancel          : in	 std_logic;
		somatorio       : out std_logic_vector (4 downto 0)
	);
end component;
   
	-- Declatando os sinais
	
	signal clock          : std_logic;
	signal rst            : std_logic;
	signal Produto_esc    : integer;
	signal bot_cartao     : std_logic;
	signal bot_dinheiro   : std_logic;
	signal Pag_cartao     : std_logic;
	signal Val_cartao     : std_logic_vector (4 downto 0);
	signal Mny_in         : std_logic_vector (4 downto 0);
	signal Mny_out        : std_logic_vector (4 downto 0);
	signal saida_disp     : integer;
	signal cancelar       :	std_logic;
	signal soma           : std_logic_vector (4 downto 0);
	
	
	constant max_value      : natural := 6;
	constant mim_value		: natural := 1;
	


   	signal read_Produto      : std_logic:='0';
		signal read_bot_cartao   : std_logic:='0';
		signal read_bot_dinheiro : std_logic:='0';
		signal read_Pag_cartao   : std_logic:='0';
		signal read_Mny_in       : std_logic:='0';
		signal read_cancel       : std_logic:='0';
   	signal flag_write        : std_logic:='0';  
	
		constant txt_cartao        : string := "a saida do cartao eh";
		constant txt_disp        : string := "a saida do dispenser eh";
		constant txt_troco        : string := "a saida do troco eh";

		
   	file   inputs_Produto      : text open read_mode  is "Produto.txt";
		file   inputs_bot_cartao   : text open read_mode  is "bot_cartao.txt";
		file   inputs_bot_dinheiro : text open read_mode  is "bot_dinheiro.txt";
		file   inputs_Pag_cartao   : text open read_mode  is "Pag_cartao.txt";
		file   inputs_Mny_in       : text open read_mode  is "Mny_in.txt";
		file   inputs_cancel       : text open read_mode  is "cancel.txt";
   	file   outputs             : text open write_mode is "outputs.txt";


   	-- Clock period definitions
   	constant PERIOD     : time := 20 ns;
   	constant DUTY_CYCLE : real := 0.5;
   	constant OFFSET     : time := 5 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT) or Design Under Test (DUT)
DUT: ProjetoFinal 
    port map(clk		        => clock,
				Produto	        => Produto_esc,
				botao_cartao     => bot_cartao,
				botao_dinheiro   => bot_dinheiro,
				Pagamento_cartao => Pag_cartao,
				Valor_cartao     => Val_cartao,
				Money_in         => Mny_in,
				Money_out        => Mny_out,
				reset	           => rst,
				saida_dispenser  => saida_disp,
				cancel           => cancelar,
				somatorio        => soma);
		  
------------------------------------------------------------------------------------
----------------- processo para gerar o sinal de clock 
------------------------------------------------------------------------------------		
        PROCESS    -- clock process for clock
        BEGIN
				WAIT FOR (OFFSET);
            CLOCK_LOOP : LOOP
                clock <= '1';
                WAIT FOR (PERIOD);
                clock <= '0';
                WAIT FOR (PERIOD);
            END LOOP CLOCK_LOOP;
        END PROCESS;

------------------------------------------------------------------------------------
----------------- processo para gerar o estimulo de reset
------------------------------------------------------------------------------------		
	--sreset: process
	--begin
		--rst <= '1';
		--for i in 1 to 4 loop
		--	wait until rising_edge(clk);
	--	end loop;
	--	rst <= '0'; 
	--	wait;	
--	end process sreset;
	
	
------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo Produto.txt
------------------------------------------------------------------------------------
read_inputs_Produto:process
		variable linea : line;
		variable input : integer;
	begin
	    wait until rising_edge(clock);
		while not endfile(inputs_Produto) loop
		      if read_Produto = '1' then
			     readline(inputs_Produto,linea);
				 read(linea,input);
				 Produto_esc <= input;
			  end if;
			  wait for PERIOD;
		end loop;
		wait;
	end process read_inputs_Produto;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	 tb_stimulus : PROCESS
   BEGIN
        WAIT FOR (OFFSET + PERIOD);
            read_Produto <= '1';		
			for i in 0 to 1 loop
		        wait for PERIOD;
		    end loop;
            read_Produto <= '0';		
		WAIT;
   END PROCESS tb_stimulus;

   
------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo bot_cartao.txt.txt
------------------------------------------------------------------------------------
read_inputs_cartao:process
		variable linea : line;
		variable input : std_logic;
	begin
	    wait until rising_edge(clock);
		while not endfile(inputs_bot_cartao) loop
		      if read_bot_cartao = '1' then
			     readline(inputs_bot_cartao,linea);
				 read(linea,input);
				 bot_cartao <= input;
			  end if;
			  wait for PERIOD;
		end loop;
		wait;
	end process read_inputs_cartao;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	
   tb_stimulus_cartao : PROCESS
   BEGIN
        WAIT FOR (OFFSET + 2*PERIOD);
            read_bot_cartao <= '1';		
			for i in 0 to 1 loop
		        wait for PERIOD;
		    end loop;
            read_bot_cartao <= '0';		
		WAIT;
   END PROCESS tb_stimulus_cartao;	
  

 ------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo bot_dinheiro.txt
------------------------------------------------------------------------------------
read_inputs_dinheiro:process
		variable linea : line;
		variable input : std_logic;
	begin
	    wait until rising_edge(clock);
		while not endfile(inputs_bot_dinheiro) loop
		      if read_bot_dinheiro = '1' then
			     readline(inputs_bot_dinheiro,linea);
				 read(linea,input);
				 bot_dinheiro <= input;
			  end if;
			  wait for PERIOD;
		end loop;
		wait;
	end process read_inputs_dinheiro;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	
   tb_stimulus_bot_dinheiro : PROCESS
   BEGIN
        WAIT FOR (OFFSET + 2*PERIOD);
            read_bot_dinheiro <= '1';		
		        wait for PERIOD;
            read_bot_dinheiro <= '0';		
		  WAIT;
   END PROCESS tb_stimulus_bot_dinheiro;
	

 ------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo Pag_cartao.txt
------------------------------------------------------------------------------------
read_inputs_Pag_cartao:process
		variable linea : line;
		variable input : std_logic;
	begin
	    wait until rising_edge(clock);
		while not endfile(inputs_Pag_cartao) loop
		      if read_pag_cartao = '1' then
			     readline(inputs_pag_cartao,linea);
				 read(linea,input);
				 pag_cartao <= input;
			  end if;
			  wait for PERIOD;
		end loop;
		wait;
	end process read_inputs_Pag_cartao;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	
   tb_stimulus_Pag_cartao : PROCESS
   BEGIN
        WAIT FOR (OFFSET + 3*PERIOD);
            read_pag_cartao <= '1';		
		        wait for PERIOD;
            read_pag_cartao <= '0';		
		WAIT;
   END PROCESS tb_stimulus_Pag_cartao;
	
 ------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo Mny_in.txt
------------------------------------------------------------------------------------
read_inputs_Mny_in:process
		variable linea : line;
		variable input : std_logic_vector (4 downto 0);
	begin
	    wait until rising_edge(clock);
		while not endfile(inputs_mny_in) loop
		      if read_mny_in = '1' then
			     readline(inputs_mny_in,linea);
				 read(linea,input);
				 mny_in <= input;
				 WAIT FOR (PERIOD*3);
			  end if;
		end loop;
		wait;
	end process read_inputs_Mny_in;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	   tb_stimulus_mny : PROCESS
   BEGIN
        WAIT FOR (OFFSET + 2*PERIOD);
            read_mny_in <= '1';			
   END PROCESS tb_stimulus_mny;


 ------------------------------------------------------------------------------------
----------------- processo para leer os dados do arquivo cancel.txt
------------------------------------------------------------------------------------
read_inputs_cancel:process
		variable linea : line;
		variable input : std_logic;
	begin
	    wait until rising_edge(clock);
		while not endfile(inputs_cancel) loop
		      if read_cancel = '1' then
			     readline(inputs_cancel,linea);
				 read(linea,input);
				 cancelar <= input;
			  end if;
			  WAIT FOR (PERIOD*3);
		end loop;
		wait;
	end process read_inputs_cancel;	
	
------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada
------------------------------------------------------------------------------------
	
   tb_stimulus_cancel : PROCESS
   BEGIN
            WAIT FOR (OFFSET + 2*PERIOD);
            read_cancel <= '1';			
		WAIT;
   END PROCESS tb_stimulus_cancel;
	
			
------------------------------------------------------------------------------------
------ processo para gerar os estimulos de escrita do arquivo de saida
------------------------------------------------------------------------------------   
   
   escreve_outputs : PROCESS
   BEGIN
        WAIT FOR (OFFSET + 29*PERIOD);
            flag_write <= '1';		
		 WAIT;
		 
   END PROCESS escreve_outputs;   
   
-- ------------------------------------------------------------------------------------
-- ------ processo para escriber os dados de saida no arquivo .txt
-- ------------------------------------------------------------------------------------   
   
	 write_outputs:process
		 variable linea  : line;
		 variable preco_cartao : std_logic_vector (4 downto 0);
		 variable troco : std_logic_vector (4 downto 0);
		 variable dispenser : integer;
		 
	 begin
	     wait until clock ='0';
			 if (flag_write ='1')then
				 preco_cartao := Val_cartao;
				 troco := Mny_out;
				 dispenser := saida_disp;
					write(linea,txt_cartao);
					writeline(outputs,linea);
					write(linea,preco_cartao);
					writeline(outputs,linea);
					write(linea,txt_troco);
					writeline(outputs,linea);
					write(linea,troco);
					writeline(outputs,linea);
					write(linea,txt_disp);
					writeline(outputs,linea);
					write(linea,dispenser);
					writeline(outputs,linea);
			 end if;
			 wait for PERIOD;
	 end process write_outputs;   	
END;