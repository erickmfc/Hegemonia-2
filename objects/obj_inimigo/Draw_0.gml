// ================================================
// HEGEMONIA GLOBAL - OBJETO: INIMIGO
// Draw Event - Sistema Simples e Funcional
// ================================================

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

// === DESENHAR O SPRITE BASE ===
draw_self();

// ✅ CORREÇÃO: Barra de vida removida - agora é desenhada pelo obj_game_manager centralizadamente
// Isso evita conflito e piscar das barras
