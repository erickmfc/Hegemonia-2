/// @description Sistema de deseleção quando edifícios são clicados
/// MITIGAÇÃO PARA RISCO 2: Conflito de Seleção
/// Garantir que deseleção aconteça antes da seleção

function scr_deselecionar_unidades_edificio_clicado() {
    show_debug_message("🔄 Desselecionando unidades por clique em edifício");
    
    // Desselecionar todas as unidades
    with (obj_infantaria) { selecionado = false; }
    with (obj_soldado_antiaereo) { selecionado = false; }
    with (obj_tanque) { selecionado = false; }
    with (obj_blindado_antiaereo) { selecionado = false; }
    with (obj_lancha_patrulha) { selecionado = false; }
    with (obj_caca_f5) { selecionado = false; }
    with (obj_helicoptero_militar) { selecionado = false; }
    
    // Limpar unidade selecionada global
    global.unidade_selecionada = noone;
    
    show_debug_message("✅ Unidades desselecionadas com sucesso");
}
