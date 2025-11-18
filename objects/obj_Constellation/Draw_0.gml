/// @description Draw Event da Constellation

// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION (HERDA DE NAVIO_BASE)
// Draw Event - Indicadores específicos
// ===============================================

// =============================================
// DRAW - Otimizado com verificação de visibilidade
// =============================================

// ✅ OTIMIZAÇÃO: Verificar se deve desenhar
if (!scr_should_draw(id)) {
    if (instance_exists(obj_draw_optimizer)) {
        obj_draw_optimizer.objects_skipped++;
    }
    exit;
}

// Chamar o Draw do objeto pai (herda indicadores básicos)
if (object_get_parent(object_index) != -1) {
    event_inherited();
}

// === INDICADORES ESPECÍFICOS DO CONSTELLATION ===
if (selecionado) {
    // Círculo de seleção específico do Constellation
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, 35, false);
    draw_set_alpha(1.0);
    
    // Círculo de alcance dos mísseis (800px) - 50% mais transparente
    draw_set_color(c_red);
    draw_set_alpha(0.06);
    draw_circle(x, y, 800, false);
    draw_set_alpha(1.0);
    
    // Círculo de alcance do radar (1000px)
    draw_set_color(c_blue);
    draw_set_alpha(0.08);
    draw_circle(x, y, 1000, false);
    draw_set_alpha(1.0);
    
    // ✅ CORREÇÃO: Removida linha amarela direta - usa apenas caminho A* do objeto pai
    // A linha do caminho A* já é desenhada pelo obj_navio_base (objeto pai)
    
    // Desenhar linha quando atacando (apenas para alvo)
    if (variable_instance_exists(id, "estado") && estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "alvo_unidade") && instance_exists(alvo_unidade)) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
            draw_line(x, y, alvo_unidade.x, alvo_unidade.y);
        }
    }
    
    // ✅ CORREÇÃO: Usar fonte padrão como no navio de transporte
    draw_set_font(-1);
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(x, y - 65, "CONSTELLATION");
}