// ================================================
// HEGEMONIA GLOBAL - CAÇA F-6 (ALVO DE TESTE)
// Destroy Event - Limpeza e feedback de teste
// ================================================

// === EFEITO DE DESTRUIÇÃO ===
if (object_exists(obj_explosao_aquatica)) {
    var _explosao = instance_create_depth(x, y, 0, obj_explosao_aquatica);
    if (instance_exists(_explosao)) {
        _explosao.image_blend = make_color_rgb(255, 150, 0); // Laranja para F-6
        _explosao.image_xscale = 2.5;
        _explosao.image_yscale = 2.5;
        _explosao.image_angle = random(360);
    }
}

// === LIMPEZA DA LISTA DE PATRULHA ===
if (ds_exists(pontos_patrulha, ds_type_list)) {
    ds_list_destroy(pontos_patrulha);
}

show_debug_message("💥 F-6 DESTRUÍDO! Teste de míssil ar-ar concluído com sucesso!");
show_debug_message("🎯 O sistema de interceptação funcionou perfeitamente!");
