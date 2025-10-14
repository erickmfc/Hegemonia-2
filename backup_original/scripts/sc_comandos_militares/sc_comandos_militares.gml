/// @description Sistema Tático de Comandos Militares
/// @param {id} unidade_id ID da unidade
/// @param {string} comando Tipo de comando (ATACAR, SEGUIR, PATRULHAR, LIVRE)
/// @param {bool} ativar Se deve ativar ou desativar o comando

function sc_comando_militar(unidade_id, comando, ativar) {
    
    // Verificar se a unidade existe
    if (!instance_exists(unidade_id)) {
        show_debug_message("❌ ERRO: Unidade não existe - ID: " + string(unidade_id));
        return false;
    }
    
    var unidade = unidade_id;
    
    // Verificar se a unidade tem as variáveis necessárias
    if (!variable_instance_exists(unidade, "comando_atual")) {
        show_debug_message("❌ ERRO: Unidade não tem comando_atual - ID: " + string(unidade_id));
        return false;
    }
    
    // === APLICAR COMANDO TÁTICO ===
    if (ativar) {
        // Ativar comando
        unidade.comando_atual = comando;
        
        switch (comando) {
            case "ATACAR":
                // ATAQUE-MOVIMENTO: Comando ofensivo principal
                if (variable_instance_exists(unidade, "alvo_atual")) {
                    unidade.alvo_atual = noone;
                }
                if (variable_instance_exists(unidade, "destino_ataque_x")) {
                    unidade.destino_ataque_x = noone;
                    unidade.destino_ataque_y = noone;
                }
                show_debug_message("⚔️ ATAQUE-MOVIMENTO ATIVADO - Unidade: " + string(unidade_id));
                show_debug_message("📋 Doutrina: Ataca alvos específicos ou move atacando inimigos no caminho");
                break;
                
            case "SEGUIR":
                // ESCOLTA: Comando de apoio e proteção
                if (variable_instance_exists(unidade, "unidade_seguindo")) {
                    unidade.unidade_seguindo = noone;
                }
                show_debug_message("➡️ ESCOLTA ATIVADA - Unidade: " + string(unidade_id));
                show_debug_message("📋 Doutrina: Segue e ajuda automaticamente em combate");
                break;
                
            case "PATRULHAR":
                // VIGILÂNCIA: Comando de defesa e vigilância
                if (variable_instance_exists(unidade, "patrulha_ativa")) {
                    unidade.patrulha_ativa = true;
                }
                if (variable_instance_exists(unidade, "ponto_patrulha_a_x")) {
                    unidade.ponto_patrulha_a_x = unidade.x;
                    unidade.ponto_patrulha_a_y = unidade.y;
                }
                if (variable_instance_exists(unidade, "ponto_patrulha_b_x")) {
                    unidade.ponto_patrulha_b_x = unidade.x + 100;
                    unidade.ponto_patrulha_b_y = unidade.y + 100;
                }
                if (variable_instance_exists(unidade, "indo_para_ponto_b")) {
                    unidade.indo_para_ponto_b = true;
                }
                show_debug_message("🔄 VIGILÂNCIA ATIVADA - Unidade: " + string(unidade_id));
                show_debug_message("📋 Doutrina: Patrulha entre pontos, ataca e retorna à rota");
                break;
                
            case "LIVRE":
                show_debug_message("🚶 MODO LIVRE ATIVADO - Unidade: " + string(unidade_id));
                break;
        }
        
    } else {
        // Desativar comando
        unidade.comando_atual = "LIVRE";
        
        switch (comando) {
            case "ATACAR":
                if (variable_instance_exists(unidade, "alvo_atual")) {
                    unidade.alvo_atual = noone;
                }
                if (variable_instance_exists(unidade, "destino_ataque_x")) {
                    unidade.destino_ataque_x = noone;
                    unidade.destino_ataque_y = noone;
                }
                show_debug_message("⚔️ ATAQUE-MOVIMENTO DESATIVADO - Unidade: " + string(unidade_id));
                break;
                
            case "SEGUIR":
                if (variable_instance_exists(unidade, "unidade_seguindo")) {
                    unidade.unidade_seguindo = noone;
                }
                if (variable_instance_exists(unidade, "movendo")) {
                    unidade.movendo = false;
                }
                show_debug_message("➡️ ESCOLTA DESATIVADA - Unidade: " + string(unidade_id));
                break;
                
            case "PATRULHAR":
                if (variable_instance_exists(unidade, "patrulha_ativa")) {
                    unidade.patrulha_ativa = false;
                }
                if (variable_instance_exists(unidade, "movendo")) {
                    unidade.movendo = false;
                }
                show_debug_message("🔄 VIGILÂNCIA DESATIVADA - Unidade: " + string(unidade_id));
                break;
        }
    }
    
    return true;
}

/// @description Processar clique direito seguindo doutrina de combate
/// @param {id} unidade_id ID da unidade
/// @param {real} mouse_x Posição X do mouse
/// @param {real} mouse_y Posição Y do mouse

function sc_processar_clique_direito(unidade_id, mouse_x, mouse_y) {
    
    if (!instance_exists(unidade_id)) return false;
    
    var unidade = unidade_id;
    
    // Verificar comando atual
    if (!variable_instance_exists(unidade, "comando_atual")) return false;
    
    switch (unidade.comando_atual) {
        case "ATACAR":
            // ATAQUE-MOVIMENTO: Verificar se clicou em inimigo ou ponto
            var inimigo_proximo = instance_nearest(mouse_x, mouse_y, obj_infantaria);
            
            if (inimigo_proximo != noone && inimigo_proximo != unidade_id) {
                // ATAQUE ESPECÍFICO: Foca no inimigo selecionado
                if (variable_instance_exists(unidade, "alvo_atual")) {
                    unidade.alvo_atual = inimigo_proximo;
                }
                show_debug_message("⚔️ ATAQUE ESPECÍFICO - Alvo definido: " + string(inimigo_proximo));
                show_debug_message("📋 Doutrina: Perseguirá implacavelmente este alvo");
                return true;
            } else {
                // ATAQUE-MOVIMENTO: Move para ponto atacando no caminho
                if (variable_instance_exists(unidade, "destino_ataque_x")) {
                    unidade.destino_ataque_x = mouse_x;
                    unidade.destino_ataque_y = mouse_y;
                }
                if (variable_instance_exists(unidade, "movendo")) {
                    unidade.movendo = true;
                }
                show_debug_message("⚔️ ATAQUE-MOVIMENTO - Destino: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
                show_debug_message("📋 Doutrina: Atacará inimigos encontrados no caminho");
                return true;
            }
            break;
            
        case "SEGUIR":
            // ESCOLTA: Seguir unidade e ajudar em combate
            var unidade_proxima = instance_nearest(mouse_x, mouse_y, obj_infantaria);
            if (unidade_proxima != noone && unidade_proxima != unidade_id) {
                if (variable_instance_exists(unidade, "unidade_seguindo")) {
                    unidade.unidade_seguindo = unidade_proxima;
                }
                show_debug_message("➡️ ESCOLTA - Unidade definida para seguir: " + string(unidade_proxima));
                show_debug_message("📋 Doutrina: Seguirá e ajudará automaticamente em combate");
                return true;
            }
            break;
            
        case "PATRULHAR":
            // VIGILÂNCIA: Definir rota de patrulha
            if (variable_instance_exists(unidade, "patrulha_ativa") && unidade.patrulha_ativa) {
                if (variable_instance_exists(unidade, "indo_para_ponto_b") && unidade.indo_para_ponto_b) {
                    // Define o ponto B da patrulha
                    if (variable_instance_exists(unidade, "ponto_patrulha_b_x")) {
                        unidade.ponto_patrulha_b_x = mouse_x;
                        unidade.ponto_patrulha_b_y = mouse_y;
                    }
                    unidade.indo_para_ponto_b = false;
                    show_debug_message("🔄 VIGILÂNCIA - Ponto B definido: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
                } else {
                    // Define o ponto A da patrulha
                    if (variable_instance_exists(unidade, "ponto_patrulha_a_x")) {
                        unidade.ponto_patrulha_a_x = mouse_x;
                        unidade.ponto_patrulha_a_y = mouse_y;
                    }
                    unidade.indo_para_ponto_b = true;
                    show_debug_message("🔄 VIGILÂNCIA - Ponto A definido: (" + string(mouse_x) + ", " + string(mouse_y) + ")");
                }
                
                // Inicia movimento para o ponto definido
                if (variable_instance_exists(unidade, "destino_x")) {
                    unidade.destino_x = mouse_x;
                    unidade.destino_y = mouse_y;
                }
                if (variable_instance_exists(unidade, "movendo")) {
                    unidade.movendo = true;
                }
                show_debug_message("📋 Doutrina: Patrulhará entre pontos, atacará e retornará à rota");
                return true;
            }
            break;
            
        case "LIVRE":
            // Movimento normal
            if (variable_instance_exists(unidade, "destino_x")) {
                unidade.destino_x = mouse_x;
                unidade.destino_y = mouse_y;
            }
            if (variable_instance_exists(unidade, "movendo")) {
                unidade.movendo = true;
            }
            show_debug_message("🚶 Movimento normal iniciado");
            return true;
            break;
    }
    
    return false;
}

/// @description Verificar regras de engajamento para combate
/// @param {id} unidade_id ID da unidade
/// @param {id} inimigo_id ID do inimigo detectado

function sc_regras_engajamento(unidade_id, inimigo_id) {
    
    if (!instance_exists(unidade_id) || !instance_exists(inimigo_id)) return false;
    
    var unidade = unidade_id;
    
    // Verificar comando atual
    if (!variable_instance_exists(unidade, "comando_atual")) return false;
    
    switch (unidade.comando_atual) {
        case "ATACAR":
            // ATAQUE-MOVIMENTO: Sempre engaja inimigos
            if (variable_instance_exists(unidade, "alvo_atual") && unidade.alvo_atual == noone) {
                unidade.alvo_atual = inimigo_id;
                show_debug_message("⚔️ ATAQUE-MOVIMENTO - Engajando inimigo no caminho: " + string(inimigo_id));
            }
            return true;
            
        case "SEGUIR":
            // ESCOLTA: Ajuda automaticamente se o alvo seguido estiver em combate
            if (variable_instance_exists(unidade, "unidade_seguindo") && unidade.unidade_seguindo != noone) {
                var alvo_seguido = unidade.unidade_seguindo;
                if (instance_exists(alvo_seguido) && variable_instance_exists(alvo_seguido, "alvo_atual")) {
                    if (alvo_seguido.alvo_atual == inimigo_id) {
                        if (variable_instance_exists(unidade, "alvo_atual")) {
                            unidade.alvo_atual = inimigo_id;
                        }
                        show_debug_message("➡️ ESCOLTA - Ajudando alvo seguido contra: " + string(inimigo_id));
                        return true;
                    }
                }
            }
            return false;
            
        case "PATRULHAR":
            // VIGILÂNCIA: Interrompe patrulha para atacar, depois retorna
            if (variable_instance_exists(unidade, "alvo_atual") && unidade.alvo_atual == noone) {
                unidade.alvo_atual = inimigo_id;
                show_debug_message("🔄 VIGILÂNCIA - Interrompendo patrulha para atacar: " + string(inimigo_id));
            }
            return true;
            
        case "LIVRE":
            // MODO LIVRE: Não engaja automaticamente
            return false;
    }
    
    return false;
}
