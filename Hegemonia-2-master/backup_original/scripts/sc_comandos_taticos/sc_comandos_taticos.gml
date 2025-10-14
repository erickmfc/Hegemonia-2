// ================================================
// HEGEMONIA GLOBAL - SISTEMA DE COMANDOS TÁTICOS
// Script para gerenciar comandos avançados de unidades
// ================================================

/// @description Aplicar comando tático às unidades selecionadas
/// @param {string} _comando Tipo de comando ("ataque", "defesa", "retirada", "aguardar")
/// @param {real} _world_x Posição X alvo (opcional)
/// @param {real} _world_y Posição Y alvo (opcional)
function aplicar_comando_tatico(_comando, _world_x = 0, _world_y = 0) {
    
    var unidades_afetadas = 0;
    
    switch (_comando) {
        case "ataque":
            // COMANDO: ATAQUE EM FORMAÇÃO
            with (obj_infantaria) {
                if (selecionado) {
                    estado = "atacando";
                    comando_atual = "ATAQUE";
                    // Procurar inimigo mais próximo
                    alvo = instance_nearest(x, y, obj_inimigo);
                    if (alvo != noone) {
                        // Mover em direção ao inimigo
                        destino_x = alvo.x;
                        destino_y = alvo.y;
                        estado = "movendo";
                    }
                    unidades_afetadas++;
                }
            }
            
            with (obj_tanque) {
                if (selecionado) {
                    estado = "atacando";
                    comando_atual = "ATAQUE";
                    // Procurar inimigo mais próximo
                    alvo = instance_nearest(x, y, obj_inimigo);
                    if (alvo != noone) {
                        // Mover em direção ao inimigo
                        destino_x = alvo.x;
                        destino_y = alvo.y;
                        estado = "movendo";
                    }
                    unidades_afetadas++;
                }
            }
            break;
            
        case "defesa":
            // COMANDO: DEFENDER POSIÇÃO
            with (obj_infantaria) {
                if (selecionado) {
                    estado = "parado";
                    comando_atual = "DEFESA";
                    // Limpar patrulha e ficar em posição
                    if (variable_instance_exists(id, "patrulha")) {
                        ds_list_clear(patrulha);
                    }
                    // Ativar modo defensivo
                    modo_defensivo = true;
                    unidades_afetadas++;
                }
            }
            
            with (obj_tanque) {
                if (selecionado) {
                    estado = "parado";
                    comando_atual = "DEFESA";
                    // Limpar patrulha e ficar em posição
                    if (variable_instance_exists(id, "patrulha")) {
                        ds_list_clear(patrulha);
                    }
                    modo_patrulha = false;
                    // Ativar modo defensivo
                    modo_defensivo = true;
                    unidades_afetadas++;
                }
            }
            break;
            
        case "retirada":
            // COMANDO: RETIRADA TÁTICA
            with (obj_infantaria) {
                if (selecionado) {
                    estado = "movendo";
                    comando_atual = "RETIRADA";
                    // Mover para longe dos inimigos
                    var inimigo_proximo = instance_nearest(x, y, obj_inimigo);
                    if (inimigo_proximo != noone) {
                        var dir = point_direction(inimigo_proximo.x, inimigo_proximo.y, x, y);
                        destino_x = x + lengthdir_x(200, dir);
                        destino_y = y + lengthdir_y(200, dir);
                    } else {
                        // Se não há inimigos, mover para base
                        destino_x = x - 300;
                        destino_y = y - 300;
                    }
                    alvo = noone;
                    unidades_afetadas++;
                }
            }
            
            with (obj_tanque) {
                if (selecionado) {
                    estado = "movendo";
                    comando_atual = "RETIRADA";
                    // Mover para longe dos inimigos
                    var inimigo_proximo = instance_nearest(x, y, obj_inimigo);
                    if (inimigo_proximo != noone) {
                        var dir = point_direction(inimigo_proximo.x, inimigo_proximo.y, x, y);
                        destino_x = x + lengthdir_x(250, dir);
                        destino_y = y + lengthdir_y(250, dir);
                    } else {
                        // Se não há inimigos, mover para base
                        destino_x = x - 300;
                        destino_y = y - 300;
                    }
                    alvo = noone;
                    unidades_afetadas++;
                }
            }
            break;
            
        case "aguardar":
            // COMANDO: AGUARDAR ORDENS
            with (obj_infantaria) {
                if (selecionado) {
                    estado = "parado";
                    comando_atual = "AGUARDANDO";
                    alvo = noone;
                    // Limpar patrulha
                    if (variable_instance_exists(id, "patrulha")) {
                        ds_list_clear(patrulha);
                    }
                    unidades_afetadas++;
                }
            }
            
            with (obj_tanque) {
                if (selecionado) {
                    estado = "parado";
                    comando_atual = "AGUARDANDO";
                    alvo = noone;
                    // Limpar patrulha
                    if (variable_instance_exists(id, "patrulha")) {
                        ds_list_clear(patrulha);
                    }
                    modo_patrulha = false;
                    unidades_afetadas++;
                }
            }
            break;
    }
    
    show_debug_message("Comando '" + _comando + "' aplicado a " + string(unidades_afetadas) + " unidades");
}
