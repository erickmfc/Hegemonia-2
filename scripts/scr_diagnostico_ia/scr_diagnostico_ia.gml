/// @description Diagnóstico completo da IA do Presidente
function scr_diagnostico_ia() {
    show_debug_message("========================================");
    show_debug_message("🔍 DIAGNÓSTICO DA IA PRESIDENTE");
    show_debug_message("========================================");
    
    // Verificar se presidente existe
    var _presidente = instance_find(obj_presidente_1, 0);
    if (_presidente == noone) {
        show_debug_message("❌ PROBLEMA: obj_presidente_1 não existe no mapa!");
        return;
    }
    show_debug_message("✅ Presidente encontrado - ID: " + string(_presidente));
    
    // Contar quartéis da IA
    var _quartel_ia = 0;
    with (obj_quartel) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _quartel_ia++;
        }
    }
    show_debug_message("📊 Quartéis da IA: " + string(_quartel_ia));
    
    // Contar tropas da IA com detalhes
    var _tropas_ia = 0;
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _tropas_ia++;
            var _estado_str = variable_instance_exists(id, "estado") ? estado : "?";
            var _dest_x = variable_instance_exists(id, "destino_x") ? string(round(destino_x)) : "?";
            var _dest_y = variable_instance_exists(id, "destino_y") ? string(round(destino_y)) : "?";
            show_debug_message("  - Infantaria ID:" + string(id) + 
                " Pos:(" + string(round(x)) + "," + string(round(y)) + ")" +
                " Estado:" + _estado_str +
                " Destino:(" + _dest_x + "," + _dest_y + ")" +
                " ModoAtaque:" + (variable_instance_exists(id, "modo_ataque") ? string(modo_ataque) : "?"));
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 2) {
            _tropas_ia++;
        }
    }
    show_debug_message("📊 Tropas da IA: " + string(_tropas_ia));
    
    // Contar tropas do jogador
    var _tropas_jogador = 0;
    with (obj_infantaria) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            _tropas_jogador++;
        }
    }
    with (obj_tanque) {
        if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == 1) {
            _tropas_jogador++;
        }
    }
    show_debug_message("📊 Tropas do Jogador: " + string(_tropas_jogador));
    
    // Verificar recursos da IA
    show_debug_message("💰 Recursos IA: $" + string(global.ia_dinheiro) + " | Minério: " + string(global.ia_minerio));
    
    // Verificar timer da IA
    if (variable_instance_exists(_presidente, "timer_decisao")) {
        show_debug_message("⏱️ Timer decisão: " + string(_presidente.timer_decisao) + " / " + string(_presidente.intervalo_decisao));
    }
    
    show_debug_message("========================================");
}

