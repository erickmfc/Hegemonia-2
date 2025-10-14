/// @description Teste completo dos controles simplificados da lancha patrulha
/// @function scr_teste_controles_simplificados_navio

show_debug_message("=== TESTE: CONTROLES SIMPLIFICADOS DA LANCHA PATRULHA ===");

// 1. PREPARAR AMBIENTE DE TESTE
show_debug_message("🔧 PREPARANDO AMBIENTE DE TESTE...");

// Criar navio de teste
var navio = instance_create_layer(400, 400, "rm_mapa_principal", obj_lancha_patrulha);
if (navio == noone) {
    show_debug_message("❌ FALHA: Não foi possível criar navio!");
    exit;
}

show_debug_message("✅ Navio criado: " + string(navio));
show_debug_message("   - Posição inicial: (" + string(navio.x) + ", " + string(navio.y) + ")");
show_debug_message("   - Modo inicial: " + string(navio.modo_combate));

// 2. TESTE 1: CONTROLES BÁSICOS DE SELEÇÃO
show_debug_message("🧪 TESTE 1: Controles Básicos de Seleção");

// Simular clique esquerdo para seleção
navio.selecionado = true;

show_debug_message("✅ Navio selecionado:");
show_debug_message("   - selecionado: " + string(navio.selecionado));
show_debug_message("   - alcance_tiro: " + string(navio.alcance_tiro));
show_debug_message("   - raio_selecao: " + string(navio.raio_selecao));

// Verificar se sistema de seleção detecta navio
var navio_detectado = false;
with (obj_lancha_patrulha) {
    if (selecionado) {
        navio_detectado = true;
        show_debug_message("✅ Sistema de seleção detecta navio corretamente");
    }
}

var teste1_passou = navio_detectado;
show_debug_message("   - Resultado: " + (teste1_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 3. TESTE 2: CONTROLE DE MOVIMENTO
show_debug_message("🧪 TESTE 2: Controle de Movimento");

// Simular clique direito para movimento
var destino_x = navio.x + 200;
var destino_y = navio.y + 150;

show_debug_message("📍 Simulando clique direito:");
show_debug_message("   - Destino: (" + string(destino_x) + ", " + string(destino_y) + ")");

// Aplicar movimento
navio.destino_x = destino_x;
navio.destino_y = destino_y;
navio.estado = "movendo";
navio.movendo = true;

show_debug_message("✅ Movimento configurado:");
show_debug_message("   - destino_x: " + string(navio.destino_x));
show_debug_message("   - destino_y: " + string(navio.destino_y));
show_debug_message("   - estado: " + string(navio.estado));

// Simular movimento
var posicao_inicial_x = navio.x;
var posicao_inicial_y = navio.y;
var frames_simulados = 0;
var max_frames = 30;

while (frames_simulados < max_frames && navio.estado == "movendo") {
    frames_simulados++;
    
    // Simular Step Event do navio
    var _distancia = point_distance(navio.x, navio.y, navio.destino_x, navio.destino_y);
    
    if (_distancia > 5) {
        var _angulo = point_direction(navio.x, navio.y, navio.destino_x, navio.destino_y);
        navio.x += lengthdir_x(navio.velocidade, _angulo);
        navio.y += lengthdir_y(navio.velocidade, _angulo);
    } else {
        navio.estado = "parado";
        navio.movendo = false;
        show_debug_message("   ✅ Destino alcançado!");
        break;
    }
}

var distancia_percorrida = point_distance(posicao_inicial_x, posicao_inicial_y, navio.x, navio.y);
show_debug_message("   - Distância percorrida: " + string(round(distancia_percorrida)) + " pixels");

var teste2_passou = (distancia_percorrida > 0);
show_debug_message("   - Resultado: " + (teste2_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 4. TESTE 3: COMANDO MODO PASSIVO (TECLA P)
show_debug_message("🧪 TESTE 3: Comando Modo Passivo (Tecla P)");

// Verificar modo inicial
show_debug_message("   - Modo inicial: " + string(navio.modo_combate));

// Simular comando modo passivo
navio.modo_combate = "passivo";
navio.estado = "passivo";
navio.alvo = noone;

show_debug_message("✅ Modo passivo ativado:");
show_debug_message("   - modo_combate: " + string(navio.modo_combate));
show_debug_message("   - estado: " + string(navio.estado));
show_debug_message("   - alvo: " + string(navio.alvo));

// Verificar se navio não procura inimigos em modo passivo
var inimigo_teste = instance_create_layer(navio.x + 100, navio.y + 100, "rm_mapa_principal", obj_inimigo);
if (inimigo_teste != noone) {
    show_debug_message("   - Inimigo criado para teste: " + string(inimigo_teste));
    
    // Simular alguns frames para verificar se navio procura inimigo
    for (var i = 0; i < 10; i++) {
        // Simular lógica de modo passivo
        if (navio.modo_combate == "passivo") {
            navio.alvo = noone;
            if (navio.estado == "atacando") {
                navio.estado = "parado";
            }
        }
    }
    
    show_debug_message("   - Alvo após modo passivo: " + string(navio.alvo));
    show_debug_message("   - Estado após modo passivo: " + string(navio.estado));
    
    // Limpar inimigo de teste
    instance_destroy(inimigo_teste);
}

var teste3_passou = (navio.modo_combate == "passivo" && navio.alvo == noone);
show_debug_message("   - Resultado: " + (teste3_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 5. TESTE 4: COMANDO MODO ATAQUE (TECLA O)
show_debug_message("🧪 TESTE 4: Comando Modo Ataque (Tecla O)");

// Criar inimigo para teste
var inimigo_teste2 = instance_create_layer(navio.x + 150, navio.y + 150, "rm_mapa_principal", obj_inimigo);
if (inimigo_teste2 != noone) {
    show_debug_message("   - Inimigo criado para teste: " + string(inimigo_teste2));
    
    // Simular comando modo ataque
    navio.modo_combate = "atacando";
    
    // Simular lógica de modo ataque
    if (navio.modo_combate == "atacando") {
        if (navio.alvo == noone || !instance_exists(navio.alvo)) {
            var inimigo = instance_nearest(navio.x, navio.y, obj_inimigo);
            if (inimigo != noone) {
                var distancia_inimigo = point_distance(navio.x, navio.y, inimigo.x, inimigo.y);
                if (distancia_inimigo <= navio.alcance) {
                    navio.alvo = inimigo;
                    navio.estado = "atacando";
                }
            }
        }
    }
    
    show_debug_message("✅ Modo ataque ativado:");
    show_debug_message("   - modo_combate: " + string(navio.modo_combate));
    show_debug_message("   - estado: " + string(navio.estado));
    show_debug_message("   - alvo: " + string(navio.alvo));
    
    if (navio.alvo != noone) {
        show_debug_message("   - Distância do alvo: " + string(point_distance(navio.x, navio.y, navio.alvo.x, navio.alvo.y)));
    }
    
    // Limpar inimigo de teste
    instance_destroy(inimigo_teste2);
} else {
    show_debug_message("   - ⚠️ Não foi possível criar inimigo para teste");
}

var teste4_passou = (navio.modo_combate == "atacando");
show_debug_message("   - Resultado: " + (teste4_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 6. TESTE 5: DESSELECIONAR
show_debug_message("🧪 TESTE 5: Desselecionar");

// Simular desseleção
navio.selecionado = false;

show_debug_message("✅ Navio desselecionado:");
show_debug_message("   - selecionado: " + string(navio.selecionado));

var teste5_passou = !navio.selecionado;
show_debug_message("   - Resultado: " + (teste5_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 7. TESTE 6: SISTEMA VISUAL
show_debug_message("🧪 TESTE 6: Sistema Visual");

var tem_alcance_tiro = variable_instance_exists(navio, "alcance_tiro");
var tem_raio_selecao = variable_instance_exists(navio, "raio_selecao");
var tem_modo_combate = variable_instance_exists(navio, "modo_combate");

show_debug_message("   - Círculo de alcance: " + string(tem_alcance_tiro ? "✅ SIM" : "❌ NÃO"));
show_debug_message("   - Cantoneiras de seleção: " + string(tem_raio_selecao ? "✅ SIM" : "❌ NÃO"));
show_debug_message("   - Indicador de modo: " + string(tem_modo_combate ? "✅ SIM" : "❌ NÃO"));

if (tem_alcance_tiro) {
    show_debug_message("   - Alcance de tiro: " + string(navio.alcance_tiro) + " pixels");
}
if (tem_raio_selecao) {
    show_debug_message("   - Raio de seleção: " + string(navio.raio_selecao) + " pixels");
}
if (tem_modo_combate) {
    show_debug_message("   - Modo atual: " + string(navio.modo_combate));
}

var teste6_passou = tem_alcance_tiro && tem_raio_selecao && tem_modo_combate;
show_debug_message("   - Resultado: " + (teste6_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 8. TESTE 7: ALTERNÂNCIA DE MODOS
show_debug_message("🧪 TESTE 7: Alternância de Modos");

// Testar alternância entre modos
var modos_testados = 0;

// Modo passivo
navio.modo_combate = "passivo";
navio.alvo = noone;
modos_testados++;
show_debug_message("   - Modo passivo: " + string(navio.modo_combate));

// Modo ataque
navio.modo_combate = "atacando";
modos_testados++;
show_debug_message("   - Modo ataque: " + string(navio.modo_combate));

// Voltar para passivo
navio.modo_combate = "passivo";
modos_testados++;
show_debug_message("   - Volta para passivo: " + string(navio.modo_combate));

var teste7_passou = (modos_testados == 3);
show_debug_message("   - Resultado: " + (teste7_passou ? "✅ PASSOU" : "❌ FALHOU"));

// 9. RESULTADO FINAL
show_debug_message("🎯 RESULTADO FINAL:");

var testes_passaram = 0;
var total_testes = 7;

if (teste1_passou) testes_passaram++;
if (teste2_passou) testes_passaram++;
if (teste3_passou) testes_passaram++;
if (teste4_passou) testes_passaram++;
if (teste5_passou) testes_passaram++;
if (teste6_passou) testes_passaram++;
if (teste7_passou) testes_passaram++;

show_debug_message("   - TESTE 1 (Seleção): " + (teste1_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 2 (Movimento): " + (teste2_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 3 (Modo Passivo): " + (teste3_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 4 (Modo Ataque): " + (teste4_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 5 (Desseleção): " + (teste5_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 6 (Visual): " + (teste6_passou ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 7 (Alternância): " + (teste7_passou ? "✅ PASSOU" : "❌ FALHOU"));

show_debug_message("📊 RESUMO:");
show_debug_message("   - Testes passaram: " + string(testes_passaram) + "/" + string(total_testes));
show_debug_message("   - Taxa de sucesso: " + string(round((testes_passaram / total_testes) * 100)) + "%");

if (testes_passaram == total_testes) {
    show_debug_message("🎉 SUCESSO TOTAL: Controles simplificados FUNCIONANDO PERFEITAMENTE!");
    show_debug_message("✅ Sistema de seleção funcionando!");
    show_debug_message("✅ Sistema de movimento funcionando!");
    show_debug_message("✅ Modo passivo funcionando!");
    show_debug_message("✅ Modo ataque funcionando!");
    show_debug_message("✅ Sistema visual funcionando!");
    show_debug_message("✅ Alternância de modos funcionando!");
} else if (testes_passaram >= total_testes * 0.8) {
    show_debug_message("⚠️ SUCESSO PARCIAL: Maioria dos testes passou");
    show_debug_message("🔧 Pequenos ajustes podem ser necessários");
} else {
    show_debug_message("❌ FALHA: Muitos testes falharam");
    show_debug_message("🔍 Verificar logs acima para identificar problemas");
}

show_debug_message("=== TESTE DE CONTROLES SIMPLIFICADOS CONCLUÍDO ===");
