-- Quartus II VHDL Template
-- Four-State Mealy State Machine

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProjetoFinal is

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
		--visor           : out string;
		cancel          : in	 std_logic;
		somatorio       : out std_logic_vector (4 downto 0)
	);

end entity;

architecture rtl of ProjetoFinal is

	TYPE Produtos IS ARRAY (0 TO 7) OF std_logic_vector(4 DOWNTO 0);
	signal preco_produtos : Produtos;

	-- Build an enumerated type for the state machine
	type state_type is (StandBy, TipoPagamento, Cartao, Dinheiro, SomaDinheiro, Troco, Dispenser, Cancelar);

	-- Register to hold the current state
	signal state : state_type;
	
	signal preco  : std_logic_vector(4 downto 0);
	signal naopago  : std_logic;
	signal soma   : unsigned (4 downto 0) := "00000";
	signal outros : unsigned (4 downto 0) := "00000";

begin

	preco_produtos <=("00001", "00101", "01010", "00011", "00111",
									"00010", "01000", "10010");

	process (clk, reset)
	begin

		if reset = '1' then
			state <= StandBy;

		elsif (rising_edge(clk)) then

			-- Faz a troca de estados
			case state is
				when StandBy=>
					if Produto < 8 then
						state <= TipoPagamento;
					else
						state <= StandBy;
					end if;					
					
				when TipoPagamento =>
					if botao_cartao = '1' then
						state <= Cartao;
					elsif botao_dinheiro = '1' then
						state <= Dinheiro;
					end if;
					
				when Cartao=>
					if Pagamento_cartao = '1' then
						state <= Dispenser;
					elsif Pagamento_cartao = '0' then
						state <= StandBy;
					end if;
					
				when Dinheiro=>
					if cancel = '1' then
						state <= Cancelar;
					elsif naopago = '1' then
						state <= SomaDinheiro;
					else
						state <= Troco;
					end if;
					
				when SomaDinheiro=>
						state <= Dinheiro;
						
				when Troco=>
					state <= Dispenser;
					
				when Cancelar=>
					state <= StandBy;
					
				when Dispenser=>
					state <= StandBy;
					
				when others=>
					state <= StandBy;
			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state)
			variable valor_troco  : unsigned (4 downto 0);
	begin
			case state is
				-- Após a escolha do produto
				when TipoPagamento=>
					preco <= preco_produtos(produto);
					naopago <= '1';
				-- Caso o cartão seja escolhido
				when Cartao=>
					valor_cartao <= preco;
				
				-- Caso o Dinheiro seja escolhid0
					
				when SomaDinheiro=>
					--Visor <= "Falta Dinheiro";
					somatorio <= std_logic_vector(soma);
					if soma < unsigned(preco) then
						naopago <= '1';
						soma <= soma + unsigned(Money_in);
					else
						naopago <= '0';
					end if;
					
				
				-- Calculando o troco
				when Troco=>
					valor_troco := soma - unsigned(preco);
					Money_out <= std_logic_vector(valor_troco);
					
				when Cancelar=>
					Money_out <= std_logic_vector(soma);

				when Dispenser=>
					saida_dispenser <= produto;
					
				when others=>
					outros <= "00000";
			end case;
	end process;

end rtl;
