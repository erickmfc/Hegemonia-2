// ===============================================
// HEGEMONIA GLOBAL - PADRONIZAÇÃO DE VARIÁVEIS
// Sistema para Padronizar Variáveis de Objetos
// ===============================================

/// @description Padronizar variáveis de um objeto
/// @param {real} obj_id ID do objeto
/// @param {string} tipo Tipo do objeto ("unidade" ou "estrutura")
function scr_padronizar_variaveis(obj_id, tipo) {
    if (!instance_exists(obj_id)) {
        show_debug_message("ERRO: Objeto não existe para padronização");
        return;
    }
    
    switch (tipo) {
        case "unidade":
            // Variáveis padrão para unidades
            if (!variable_instance_exists(obj_id, "selecionado")) {
                obj_id.selecionado = false;
            }
            if (!variable_instance_exists(obj_id, "estado")) {
                obj_id.estado = "parado";
            }
            if (!variable_instance_exists(obj_id, "destino_x")) {
                obj_id.destino_x = obj_id.x;
            }
            if (!variable_instance_exists(obj_id, "destino_y")) {
                obj_id.destino_y = obj_id.y;
            }
            if (!variable_instance_exists(obj_id, "patrulha")) {
                obj_id.patrulha = ds_list_create();
            }
            if (!variable_instance_exists(obj_id, "patrulha_indice")) {
                obj_id.patrulha_indice = 0;
            }
            if (!variable_instance_exists(obj_id, "modo_patrulha")) {
                obj_id.modo_patrulha = false;
            }
            if (!variable_instance_exists(obj_id, "atq_cooldown")) {
                obj_id.atq_cooldown = 0;
            }
            if (!variable_instance_exists(obj_id, "alvo")) {
                obj_id.alvo = noone;
            }
            if (!variable_instance_exists(obj_id, "categoria_alvo")) {
                obj_id.categoria_alvo = "mista";
            }
            if (!variable_instance_exists(obj_id, "seguir_alvo")) {
                obj_id.seguir_alvo = noone;
            }
            if (!variable_instance_exists(obj_id, "nacao_proprietaria")) {
                obj_id.nacao_proprietaria = 1;
            }
            if (!variable_instance_exists(obj_id, "vida")) {
                obj_id.vida = 100;
            }
            if (!variable_instance_exists(obj_id, "vida_max")) {
                obj_id.vida_max = 100;
            }
            if (!variable_instance_exists(obj_id, "dano")) {
                obj_id.dano = 25;
            }
            if (!variable_instance_exists(obj_id, "alcance_tiro")) {
                obj_id.alcance_tiro = 100;
            }
            if (!variable_instance_exists(obj_id, "atq_rate")) {
                obj_id.atq_rate = 30;
            }
            if (!variable_instance_exists(obj_id, "velocidade_movimento")) {
                obj_id.velocidade_movimento = 2;
            }
            if (!variable_instance_exists(obj_id, "velocidade_atual")) {
                obj_id.velocidade_atual = obj_id.velocidade_movimento;
            }
            if (!variable_instance_exists(obj_id, "nivel")) {
                obj_id.nivel = 1;
            }
            if (!variable_instance_exists(obj_id, "experiencia")) {
                obj_id.experiencia = 0;
            }
            if (!variable_instance_exists(obj_id, "ultimo_atacante")) {
                obj_id.ultimo_atacante = noone;
            }
            if (!variable_instance_exists(obj_id, "tempo_no_estado")) {
                obj_id.tempo_no_estado = 0;
            }
            if (!variable_instance_exists(obj_id, "cooldown_movimento")) {
                obj_id.cooldown_movimento = 0;
            }
            if (!variable_instance_exists(obj_id, "cooldown_ataque")) {
                obj_id.cooldown_ataque = 0;
            }
            if (!variable_instance_exists(obj_id, "dano_base")) {
                obj_id.dano_base = 25;
            }
            if (!variable_instance_exists(obj_id, "dano_variavel")) {
                obj_id.dano_variavel = 5;
            }
            if (!variable_instance_exists(obj_id, "raio_ataque")) {
                obj_id.raio_ataque = 100;
            }
            if (!variable_instance_exists(obj_id, "velocidade_ataque")) {
                obj_id.velocidade_ataque = 30;
            }
            if (!variable_instance_exists(obj_id, "raio_visao")) {
                obj_id.raio_visao = 150;
            }
            if (!variable_instance_exists(obj_id, "pode_mover_agua")) {
                obj_id.pode_mover_agua = false;
            }
            if (!variable_instance_exists(obj_id, "pode_mover_terra")) {
                obj_id.pode_mover_terra = true;
            }
            if (!variable_instance_exists(obj_id, "pode_mover_montanha")) {
                obj_id.pode_mover_montanha = false;
            }
            if (!variable_instance_exists(obj_id, "bonus_nivel_dano")) {
                obj_id.bonus_nivel_dano = 0.1;
            }
            if (!variable_instance_exists(obj_id, "bonus_equipamento")) {
                obj_id.bonus_equipamento = 0;
            }
            if (!variable_instance_exists(obj_id, "eficiencia_combate")) {
                obj_id.eficiencia_combate = 1.0;
            }
            if (!variable_instance_exists(obj_id, "alvo_inimigo")) {
                obj_id.alvo_inimigo = noone;
            }
            break;
            
        case "estrutura":
            // Variáveis padrão para estruturas
            if (!variable_instance_exists(obj_id, "estrutura_id")) {
                obj_id.estrutura_id = 0;
            }
            if (!variable_instance_exists(obj_id, "estrutura_tipo")) {
                obj_id.estrutura_tipo = "generica";
            }
            if (!variable_instance_exists(obj_id, "nacao_proprietaria")) {
                obj_id.nacao_proprietaria = 1;
            }
            if (!variable_instance_exists(obj_id, "custo_dinheiro")) {
                obj_id.custo_dinheiro = 100;
            }
            if (!variable_instance_exists(obj_id, "custo_minerio")) {
                obj_id.custo_minerio = 0;
            }
            if (!variable_instance_exists(obj_id, "custo_petroleo")) {
                obj_id.custo_petroleo = 0;
            }
            if (!variable_instance_exists(obj_id, "custo_populacao")) {
                obj_id.custo_populacao = 0;
            }
            if (!variable_instance_exists(obj_id, "hp_max")) {
                obj_id.hp_max = 100;
            }
            if (!variable_instance_exists(obj_id, "hp_atual")) {
                obj_id.hp_atual = obj_id.hp_max;
            }
            if (!variable_instance_exists(obj_id, "armadura")) {
                obj_id.armadura = 0;
            }
            if (!variable_instance_exists(obj_id, "producao_por_ciclo")) {
                obj_id.producao_por_ciclo = 0;
            }
            if (!variable_instance_exists(obj_id, "tipo_recurso")) {
                obj_id.tipo_recurso = "nenhum";
            }
            if (!variable_instance_exists(obj_id, "requer_agua")) {
                obj_id.requer_agua = false;
            }
            if (!variable_instance_exists(obj_id, "requer_terra")) {
                obj_id.requer_terra = true;
            }
            if (!variable_instance_exists(obj_id, "requer_eletricidade")) {
                obj_id.requer_eletricidade = false;
            }
            if (!variable_instance_exists(obj_id, "pode_upgradar")) {
                obj_id.pode_upgradar = false;
            }
            if (!variable_instance_exists(obj_id, "custo_upgrade_dinheiro")) {
                obj_id.custo_upgrade_dinheiro = 0;
            }
            if (!variable_instance_exists(obj_id, "custo_upgrade_minerio")) {
                obj_id.custo_upgrade_minerio = 0;
            }
            if (!variable_instance_exists(obj_id, "nivel_maximo")) {
                obj_id.nivel_maximo = 1;
            }
            if (!variable_instance_exists(obj_id, "posicao_valida")) {
                obj_id.posicao_valida = true;
            }
            if (!variable_instance_exists(obj_id, "estrutura_construida")) {
                obj_id.estrutura_construida = true;
            }
            if (!variable_instance_exists(obj_id, "estrutura_funcionando")) {
                obj_id.estrutura_funcionando = true;
            }
            if (!variable_instance_exists(obj_id, "estrutura_danificada")) {
                obj_id.estrutura_danificada = false;
            }
            if (!variable_instance_exists(obj_id, "manutencao_necessaria")) {
                obj_id.manutencao_necessaria = false;
            }
            if (!variable_instance_exists(obj_id, "custo_manutencao")) {
                obj_id.custo_manutencao = 0;
            }
            if (!variable_instance_exists(obj_id, "tempo_manutencao")) {
                obj_id.tempo_manutencao = 0;
            }
            if (!variable_instance_exists(obj_id, "pode_ser_atacada")) {
                obj_id.pode_ser_atacada = true;
            }
            if (!variable_instance_exists(obj_id, "conexoes_necessarias")) {
                obj_id.conexoes_necessarias = ds_list_create();
            }
            if (!variable_instance_exists(obj_id, "conexoes_ativas")) {
                obj_id.conexoes_ativas = ds_list_create();
            }
            if (!variable_instance_exists(obj_id, "efeitos_visuais")) {
                obj_id.efeitos_visuais = true;
            }
            if (!variable_instance_exists(obj_id, "efeitos_sonoros")) {
                obj_id.efeitos_sonoros = true;
            }
            if (!variable_instance_exists(obj_id, "debug_ativo")) {
                obj_id.debug_ativo = false;
            }
            if (!variable_instance_exists(obj_id, "ultima_atualizacao")) {
                obj_id.ultima_atualizacao = 0;
            }
            break;
            
        default:
            show_debug_message("AVISO: Tipo '" + tipo + "' não reconhecido para padronização");
            break;
    }
    
    show_debug_message("✅ Variáveis padronizadas para " + string(obj_id) + " (tipo: " + tipo + ")");
}
