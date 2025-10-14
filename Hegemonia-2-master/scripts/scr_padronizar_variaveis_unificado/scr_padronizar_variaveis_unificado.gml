// ===============================================
// HEGEMONIA GLOBAL - PADRONIZAÇÃO DE VARIÁVEIS
// Sistema para Padronizar Variáveis de Objetos
// ===============================================

/// @description Padronizar variáveis de um objeto
/// @param {real} obj_id ID do objeto
/// @param {string} tipo Tipo do objeto ("unidade" ou "estrutura")
function scr_padronizar_variaveis_unificado(obj_id, tipo) {
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
            
            // Variáveis específicas para unidades navais
            if (obj_id.unidade_categoria == "naval") {
                if (!variable_instance_exists(obj_id, "rastro_ativo")) {
                    obj_id.rastro_ativo = true;
                }
                if (!variable_instance_exists(obj_id, "tempo_rastro")) {
                    obj_id.tempo_rastro = 0;
                }
            }
            
            break;
            
        case "estrutura":
            // Variáveis padrão para estruturas
            if (!variable_instance_exists(obj_id, "menu_recrutamento_ativo")) {
                obj_id.menu_recrutamento_ativo = false;
            }
            if (!variable_instance_exists(obj_id, "recrutamento_em_andamento")) {
                obj_id.recrutamento_em_andamento = false;
            }
            if (!variable_instance_exists(obj_id, "unidade_sendo_treinada")) {
                obj_id.unidade_sendo_treinada = noone;
            }
            if (!variable_instance_exists(obj_id, "tempo_treinamento_restante")) {
                obj_id.tempo_treinamento_restante = 0;
            }
            if (!variable_instance_exists(obj_id, "esta_treinando")) {
                obj_id.esta_treinando = false;
            }
            if (!variable_instance_exists(obj_id, "unidades_para_criar")) {
                obj_id.unidades_para_criar = 1;
            }
            if (!variable_instance_exists(obj_id, "unidades_criadas")) {
                obj_id.unidades_criadas = 0;
            }
            if (!variable_instance_exists(obj_id, "quantidade_recrutar")) {
                obj_id.quantidade_recrutar = 1;
            }
            if (!variable_instance_exists(obj_id, "ultimo_recrutamento_tanque")) {
                obj_id.ultimo_recrutamento_tanque = false;
            }
            if (!variable_instance_exists(obj_id, "recrutar_tanque")) {
                obj_id.recrutar_tanque = false;
            }
            if (!variable_instance_exists(obj_id, "nacao_proprietaria")) {
                obj_id.nacao_proprietaria = 1;
            }
            if (!variable_instance_exists(obj_id, "unidades_disponiveis")) {
                obj_id.unidades_disponiveis = ds_list_create();
            }
            if (!variable_instance_exists(obj_id, "unidade_selecionada")) {
                obj_id.unidade_selecionada = 0;
            }
            
            break;
            
        default:
            show_debug_message("AVISO: Tipo de objeto não reconhecido para padronização: " + tipo);
            break;
    }
    
    show_debug_message("Variáveis padronizadas para " + tipo + " - ID: " + string(obj_id));
}
