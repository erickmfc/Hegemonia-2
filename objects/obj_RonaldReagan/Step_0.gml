/// @description Step 0 - Lógica de Embarque/Desembarque
// ===============================================
// HEGEMONIA GLOBAL - RONALD REAGAN (PORTA-AVIÕES)
// Step Event - Sistema de Transporte + Herança
// ===============================================

// Chamar Step do pai PRIMEIRO para garantir que todas as variáveis existam
event_inherited();

// === 1. PROCESSAR COMANDOS DO JOGADOR (SE SELECIONADO) ===
if (variable_instance_exists(id, "selecionado") && selecionado) {
    // COMANDO P - EMBARQUE/DESEMBARQUE
    if (keyboard_check_pressed(ord("P"))) {
        if (estado_transporte == NavioTransporteEstado.PARADO || 
            estado_transporte == NavioTransporteEstado.NAVEGANDO) {
            
            if (!modo_embarque) {
                if (!variable_instance_exists(id, "modo_embarque")) { modo_embarque = false; }
                if (!variable_instance_exists(id, "estado_embarque")) { estado_embarque = "navegando"; }
                modo_embarque = true;
                estado_transporte = NavioTransporteEstado.EMBARQUE_ATIVO;
                estado_embarque = "embarcando";
                show_debug_message("🚚 RONALD REAGAN - MODO EMBARQUE ATIVO");
            } else {
                estado_transporte = NavioTransporteEstado.DESEMBARCANDO;
                modo_embarque = false;
                desembarque_ativo = true;
                show_debug_message("📦 RONALD REAGAN - MODO DESEMBARQUE");
            }
        }
    }
    
    // COMANDO J - MENU DE CARGA
    if (keyboard_check_pressed(ord("J"))) {
        menu_carga_aberto = !menu_carga_aberto;
        if (menu_carga_aberto) {
            show_debug_message("📋 Menu de Carga aberto");
        } else {
            show_debug_message("✅ Menu de Carga fechado");
        }
    }
}

// === 2. SISTEMA DE EMBARQUE AUTOMÁTICO ===
if (estado_transporte == NavioTransporteEstado.EMBARQUE_ATIVO && modo_embarque) {
    var _espaco_total = avioes_max + unidades_max + soldados_max;
    var _carregamento_total = avioes_count + unidades_count + soldados_count;
    
    if (_carregamento_total >= _espaco_total) {
        modo_embarque = false;
        estado_transporte = NavioTransporteEstado.EMBARQUE_OFF;
        show_debug_message("✅ RONALD REAGAN CHEIO - Embarque desativado");
    } else {
        // Detectar infantaria
        with (obj_infantaria) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_unidade(id);
            }
        }
        
        // Detectar aeronaves F-5
        with (obj_caca_f5) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_aeronave(id);
            }
        }
        
        // Detectar helicópteros
        with (obj_helicoptero_militar) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_aeronave(id);
            }
        }
        
        // Detectar tanques
        with (obj_tanque) {
            if (nacao_proprietaria == other.nacao_proprietaria && 
                point_distance(other.x, other.y, x, y) < other.raio_embarque &&
                visible) {
                other.funcao_embarcar_veiculo(id);
            }
        }
    }
}

// === 3. SISTEMA DE DESEMBARQUE ===
if (estado_transporte == NavioTransporteEstado.DESEMBARCANDO) {
    desembarque_timer++;
    
    if (desembarque_timer >= desembarque_intervalo) {
        desembarque_timer = 0;
        
        if (soldados_count > 0) {
            funcao_desembarcar_soldado();
        } else if (unidades_count > 0) {
            funcao_desembarcar_veiculo();
        } else if (avioes_count > 0) {
            funcao_desembarcar_aeronave();
        } else {
            estado_transporte = NavioTransporteEstado.PARADO;
            desembarque_ativo = false;
            show_debug_message("✅ Desembarque completo!");
        }
    }
}

// === 4. ATUALIZAR ESTADO TRANSPORTE DURANTE MOVIMENTO ===
if (variable_instance_exists(id, "estado") && 
    (estado == LanchaState.MOVENDO || estado == LanchaState.PATRULHANDO)) {
    if (estado_transporte != NavioTransporteEstado.EMBARQUE_ATIVO && 
        estado_transporte != NavioTransporteEstado.DESEMBARCANDO) {
        estado_transporte = NavioTransporteEstado.NAVEGANDO;
    }
}
