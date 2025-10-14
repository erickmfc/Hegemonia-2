// =========================================================
// HEGEMONIA GLOBAL - UNIDADE: INFANTARIA
// Sistema de Deteccao Otimizado - Alarm[2]
// =========================================================

// A unidade so procura um novo inimigo se estiver parada
if (estado == "parado") {
    
    show_debug_message("--- Unidade " + string(id) + " (Nacao " + string(nacao_proprietaria) + ") escaneando area... ---");

    var inimigo_mais_proximo = noone;
    var menor_distancia = raio_de_visao + 1;
    
    // Buscar o inimigo mais proximo dentro do raio de visao
    with (obj_infantaria) {
        if (id != other.id && nacao_proprietaria != other.nacao_proprietaria) {
            var dist = point_distance(x, y, other.x, other.y);
            if (dist <= other.raio_de_visao && dist < menor_distancia) {
                menor_distancia = dist;
                inimigo_mais_proximo = id;
            }
        }
    }
    
    // Se encontrou um inimigo
    if (inimigo_mais_proximo != noone) {
        show_debug_message("*** INIMIGO DETECTADO! ID: " + string(inimigo_mais_proximo) + " | Distancia: " + string(menor_distancia) + " ***");
        alvo_inimigo = inimigo_mais_proximo;
        estado = "perseguindo";
        show_debug_message("!!! INICIANDO COMBATE !!!");
    } else {
        show_debug_message("Nenhum inimigo na area de deteccao.");
    }
}

// Reiniciar o alarme para proximo scan
// Frequencia baseada no estado atual
if (estado == "parado") {
    alarm[2] = 45; // Busca mais lenta quando parado
} else {
    alarm[2] = 90; // Busca menos frequente quando ocupado
}