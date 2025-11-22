/// @description Step do Quartel Marinha - Lógica de barra de vida

// === SISTEMA DE BARRA DE VIDA ===
if (hp_atual < hp_max) {
    mostrar_barra_vida = true;
    timer_barra_vida = 0;
}

if (mostrar_barra_vida) {
    timer_barra_vida++;
    if (timer_barra_vida >= duracao_barra_vida) {
        mostrar_barra_vida = false;
        timer_barra_vida = 0;
    }
}
