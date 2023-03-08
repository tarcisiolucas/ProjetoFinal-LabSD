#vsim -do tb_script.do
#puts {
#  Arquivo Exemplo de uma Vending machine
#  Laboratoria de Sistemas Digitais 
#}

# Exemplo simples de como usar um script em TCL 
# para automatizar as simulacoes com ModelSim
# Para cada novo projeto devem ser modificados 
# os nomes relativos aos arquivos dentro do projeto. 

if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -93 "ProjetoFinal.vhd"
vcom -explicit  -93 "tb_ProjetoFinal.vhd"
vsim -t 1ns   -lib work tb_ProjetoFinal
add wave sim:/tb_ProjetoFinal/*
#do {wave.do}
view wave
view structure
view signals
run 600ns
#quit -force

