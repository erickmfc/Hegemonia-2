// ================================================
// HEGEMONIA GLOBAL - ESTRUTURA: CASA
// Sistema de Evolução e Gestão de Habitação
// ================================================

// === SISTEMA DE VIDA ===
// Verificar se HP chegou a 0 e destruir
if (destrutivel && hp_atual <= 0) {
    show_debug_message("💥 Casa destruída - HP: " + string(hp_atual) + "/" + string(hp_max));
    instance_destroy();
    exit;
}

// === SISTEMA DE SELEÇÃO ===
// Verifica se o mouse está sobre a casa
var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);

// Detecta clique esquerdo para selecionar
if (_mouse_sobre && mouse_check_button_pressed(mb_left)) {
    selecionado = true;
    show_debug_message("🏠 Casa Nível " + string(nivel_casa) + " selecionada");
}

// Desseleciona se clicar fora
if (!_mouse_sobre && mouse_check_button_pressed(mb_left)) {
    selecionado = false;
}

// === SISTEMA DE EVOLUÇÃO ===
// Clique direito para evoluir quando selecionada
if (selecionado && _mouse_sobre && mouse_check_button_pressed(mb_right)) {
    if (nivel_casa < 3) {
        var _proximo_nivel = nivel_casa + 1;
        var _custo_dinheiro = 0;
        var _custo_minerio = 0;
        
        // Determinar custos baseado no próximo nível
        if (_proximo_nivel == 2) {
            _custo_dinheiro = custo_evolucao_nivel2_dinheiro;
            _custo_minerio = custo_evolucao_nivel2_minerio;
        } else if (_proximo_nivel == 3) {
            _custo_dinheiro = custo_evolucao_nivel3_dinheiro;
            _custo_minerio = custo_evolucao_nivel3_minerio;
        }
        
        // Verificar se tem recursos suficientes
        if (global.dinheiro >= _custo_dinheiro && global.minerio >= _custo_minerio) {
            // Evoluir a casa
            nivel_casa = _proximo_nivel;
            var _capacidade_anterior = capacidade_atual;
            capacidade_atual = capacidade_por_nivel[nivel_casa - 1];
            
            // Atualizar limite populacional global
            global.limite_populacional += (capacidade_atual - _capacidade_anterior);
            
            // Deduzir recursos
            global.dinheiro -= _custo_dinheiro;
            global.minerio -= _custo_minerio;
            
            show_debug_message("🏠 Casa evoluída para Nível " + string(nivel_casa) + "!");
            show_debug_message("📈 Capacidade: " + string(_capacidade_anterior) + " → " + string(capacidade_atual) + " pessoas");
            show_debug_message("💰 Custo: $" + string(_custo_dinheiro) + " + " + string(_custo_minerio) + " minério");
            show_debug_message("📊 Limite populacional total: " + string(global.limite_populacional) + " pessoas");
        } else {
            show_debug_message("❌ Recursos insuficientes para evolução!");
            show_debug_message("💰 Necessário: $" + string(_custo_dinheiro) + " + " + string(_custo_minerio) + " minério");
            show_debug_message("💵 Disponível: $" + string(global.dinheiro) + " + " + string(global.minerio) + " minério");
        }
    } else {
        show_debug_message("🏠 Casa já está no nível máximo (3)!");
    }
}

