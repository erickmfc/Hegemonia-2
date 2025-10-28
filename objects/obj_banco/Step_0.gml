// ================================================
// HEGEMONIA GLOBAL - ESTRUTURA: BANCO
// Sistema Financeiro - Empréstimos e Gestão de Dívida
// ================================================

// === SISTEMA DE VIDA ===
// Verificar se HP chegou a 0 e destruir
if (destrutivel && hp_atual <= 0) {
    show_debug_message("💥 Banco destruído - HP: " + string(hp_atual) + "/" + string(hp_max));
    instance_destroy();
    exit;
}

// === SISTEMA DE SELEÇÃO ===
// Verifica se o mouse está sobre o banco
var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);

// Detecta clique esquerdo para selecionar
if (_mouse_sobre && mouse_check_button_pressed(mb_left)) {
    selecionado = true;
    show_debug_message("🏦 Banco selecionado - Sistema financeiro ativo");
}

// Desseleciona se clicar fora
if (!_mouse_sobre && mouse_check_button_pressed(mb_left)) {
    selecionado = false;
}

// === SISTEMA DE EMPRÉSTIMOS ===
// Clique direito para acessar serviços financeiros
if (selecionado && _mouse_sobre && mouse_check_button_pressed(mb_right)) {
    // Verificar se pode pegar empréstimo
    if (global.divida_total == 0 && global.emprestimo_disponivel > 0) {
        // Oferecer empréstimo
        var _emprestimo_valor = global.emprestimo_disponivel;
        
        // Verificar se o jogador quer o empréstimo
        // Por simplicidade, vamos assumir que o jogador aceita
        // Em um jogo real, isso seria uma interface de confirmação
        
        // Processar empréstimo
        global.dinheiro += _emprestimo_valor;
        global.divida_total = _emprestimo_valor;
        global.juros_mensais = _emprestimo_valor * global.taxa_juros;
        global.emprestimo_disponivel = 0; // Não pode pegar mais empréstimos
        
        show_debug_message("💰 EMPRÉSTIMO APROVADO!");
        show_debug_message("💵 Valor: $" + string(_emprestimo_valor));
        show_debug_message("📊 Dívida total: $" + string(global.divida_total));
        show_debug_message("💸 Juros mensais: $" + string(global.juros_mensais));
        show_debug_message("⚠️ ATENÇÃO: Juros serão deduzidos automaticamente!");
        
    } else if (global.divida_total > 0) {
        // Mostrar informações da dívida
        show_debug_message("📊 SITUAÇÃO FINANCEIRA:");
        show_debug_message("💸 Dívida total: $" + string(global.divida_total));
        show_debug_message("📈 Juros mensais: $" + string(global.juros_mensais));
        show_debug_message("💰 Dinheiro atual: $" + string(global.dinheiro));
        
        // Verificar se pode pagar a dívida
        if (global.dinheiro >= global.divida_total) {
            show_debug_message("✅ Você pode pagar a dívida completa!");
            show_debug_message("💡 Pressione 'P' para pagar a dívida");
        } else {
            var _falta = global.divida_total - global.dinheiro;
            show_debug_message("❌ Faltam $" + string(_falta) + " para quitar a dívida");
        }
        
    } else {
        show_debug_message("🏦 Banco sem serviços disponíveis");
        show_debug_message("💡 Construa mais bancos para mais empréstimos");
    }
}

// === SISTEMA DE PAGAMENTO DE DÍVIDA ===
// Tecla P para pagar dívida
if (selecionado && keyboard_check_pressed(vk_p)) {
    if (global.divida_total > 0 && global.dinheiro >= global.divida_total) {
        // Pagar dívida completa
        global.dinheiro -= global.divida_total;
        global.divida_total = 0;
        global.juros_mensais = 0;
        global.emprestimo_disponivel = 20000000; // Resetar empréstimo
        
        show_debug_message("✅ DÍVIDA QUITADA!");
        show_debug_message("💰 Dinheiro restante: $" + string(global.dinheiro));
        show_debug_message("🏦 Novo empréstimo disponível!");
    } else if (global.divida_total > 0) {
        show_debug_message("❌ Dinheiro insuficiente para quitar a dívida");
        show_debug_message("💵 Necessário: $" + string(global.divida_total));
        show_debug_message("💵 Disponível: $" + string(global.dinheiro));
    } else {
        show_debug_message("✅ Nenhuma dívida pendente");
    }
}
