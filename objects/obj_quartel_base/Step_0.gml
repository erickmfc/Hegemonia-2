// ===============================================
// HEGEMONIA GLOBAL - QUARTEL BASE STEP EVENT
// Sistema de produção unificado e simplificado
// ===============================================

// === SISTEMA DE PRODUÇÃO UNIFICADO ===
if (!ds_queue_empty(fila_producao)) {
    // Obter dados da próxima unidade
    var _unidade_data = ds_queue_head(fila_producao);
    
    // Verificar recursos (apenas uma vez)
    if (!scr_verificar_recursos_unificados(_unidade_data)) {
        show_debug_message("❌ Recursos insuficientes para: " + _unidade_data.nome);
        return;
    }
    
    // Incrementar timer
    timer_producao++;
    
    // Verificar se produção concluída
    if (timer_producao >= _unidade_data.tempo_treino) {
        // Criar unidade
        var _unidade_criada = scr_criar_unidade_segura(_unidade_data);
        
        if (_unidade_criada != noone) {
            // Deduzir recursos
            scr_deduzir_recursos_unificados(_unidade_data);
            
            // Remover da fila
            ds_queue_dequeue(fila_producao);
            
            // Resetar timer
            timer_producao = 0;
            
            show_debug_message("✅ " + _unidade_data.nome + " produzida!");
        }
    }
}

// === COMANDOS DE PRODUÇÃO RÁPIDA ===
if (selecionado) {
    // Teclas numéricas para produção rápida
    if (keyboard_check_pressed(vk_numpad1)) {
        scr_adicionar_fila_producao(0); // Primeira unidade da lista
    }
    if (keyboard_check_pressed(vk_numpad2)) {
        scr_adicionar_fila_producao(1); // Segunda unidade da lista
    }
    if (keyboard_check_pressed(vk_numpad3)) {
        scr_adicionar_fila_producao(2); // Terceira unidade da lista
    }
    if (keyboard_check_pressed(vk_numpad4)) {
        scr_adicionar_fila_producao(3); // Quarta unidade da lista
    }
    
    // Tecla C para cancelar produção atual
    if (keyboard_check_pressed(ord("C"))) {
        if (!ds_queue_empty(fila_producao)) {
            ds_queue_clear(fila_producao);
            timer_producao = 0;
            show_debug_message("❌ Produção cancelada");
        }
    }
    
    // Tecla M para mostrar/esconder menu
    if (keyboard_check_pressed(ord("M"))) {
        mostrar_menu = !mostrar_menu;
        if (mostrar_menu) {
            show_debug_message("📋 Menu de produção aberto");
        } else {
            show_debug_message("📋 Menu de produção fechado");
        }
    }
}
