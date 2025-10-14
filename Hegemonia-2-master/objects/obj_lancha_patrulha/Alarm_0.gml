// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA ALARM EVENT (0)
// Timer para Restaurar Cor Normal Após Dano
// =========================================================

// --- RESTAURAR COR NORMAL ---
image_blend = c_white;

// --- FEEDBACK VISUAL ---
if (variable_instance_exists(id, "hp_atual") && variable_instance_exists(id, "hp_max")) {
    var _hp_percent = (hp_atual / hp_max) * 100;
    
    if (_hp_percent < 30) {
        show_debug_message("⚠️ Lancha crítica: " + string(round(_hp_percent)) + "% HP");
    } else if (_hp_percent < 60) {
        show_debug_message("⚠️ Lancha danificada: " + string(round(_hp_percent)) + "% HP");
    }
}
