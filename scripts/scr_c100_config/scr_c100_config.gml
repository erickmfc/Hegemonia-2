// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações

/// @description Configuração do C100 - Sistema de transporte
/// @return {struct} Configuração do C100
function scr_c100_config() {
    var config = {
        capacidade_maxima: 10,
        velocidade: 3,
        alcance: 200,
        custo_operacao: 50,
        tempo_embarque: 30,
        tempo_desembarque: 30
    };
    
    return config;
}