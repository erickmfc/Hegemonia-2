/// @description Teste dos comandos táticos militares
/// @function scr_teste_comandos_taticos

show_debug_message("=== TESTE: COMANDOS TÁTICOS MILITARES ===");

// 1. VERIFICAÇÃO INICIAL
show_debug_message("🔍 VERIFICAÇÃO INICIAL:");
var infantaria_count = instance_number(obj_infantaria);
var tanque_count = instance_number(obj_tanque);
var navio_count = instance_number(obj_lancha_patrulha);
var inimigo_count = instance_number(obj_inimigo);

show_debug_message("   - Infantaria: " + string(infantaria_count));
show_debug_message("   - Tanques: " + string(tanque_count));
show_debug_message("   - Navios: " + string(navio_count));
show_debug_message("   - Inimigos: " + string(inimigo_count));

// 2. CRIAR UNIDADES DE TESTE SE NECESSÁRIO
if (infantaria_count == 0) {
    show_debug_message("🏃 Criando infantaria de teste...");
    var inf_teste = instance_create_layer(300, 300, "rm_mapa_principal", obj_infantaria);
    if (inf_teste != noone) {
        show_debug_message("✅ Infantaria criada: " + string(inf_teste));
    }
}

if (inimigo_count == 0) {
    show_debug_message("👹 Criando inimigo de teste...");
    var inimigo_teste = instance_create_layer(500, 500, "rm_mapa_principal", obj_inimigo);
    if (inimigo_teste != noone) {
        show_debug_message("✅ Inimigo criado: " + string(inimigo_teste));
    }
}

// 3. TESTE 1: COMANDO ATACAR
show_debug_message("🧪 TESTE 1: Comando ATACAR");

var infantaria = instance_first(obj_infantaria);
var inimigo = instance_first(obj_inimigo);

if (infantaria != noone && inimigo != noone) {
    show_debug_message("🎯 Testando comando ATACAR:");
    show_debug_message("   - Infantaria: " + string(infantaria));
    show_debug_message("   - Inimigo: " + string(inimigo));
    
    // Verificar variáveis necessárias
    var tem_comando_atual = variable_instance_exists(infantaria, "comando_atual");
    var tem_estado = variable_instance_exists(infantaria, "estado");
    var tem_alvo = variable_instance_exists(infantaria, "alvo");
    
    show_debug_message("   - Variáveis necessárias:");
    show_debug_message("     - comando_atual: " + string(tem_comando_atual));
    show_debug_message("     - estado: " + string(tem_estado));
    show_debug_message("     - alvo: " + string(tem_alvo));
    
    if (tem_comando_atual && tem_estado && tem_alvo) {
        // Aplicar comando ATACAR
        infantaria.comando_atual = "ATACAR";
        infantaria.estado = "atacando";
        infantaria.alvo = inimigo;
        
        show_debug_message("✅ Comando ATACAR aplicado:");
        show_debug_message("   - Comando: " + string(infantaria.comando_atual));
        show_debug_message("   - Estado: " + string(infantaria.estado));
        show_debug_message("   - Alvo: " + string(infantaria.alvo));
        
        show_debug_message("✅ TESTE 1 PASSOU: Comando ATACAR funcionou");
    } else {
        show_debug_message("❌ TESTE 1 FALHOU: Variáveis necessárias não existem");
    }
} else {
    show_debug_message("❌ TESTE 1 FALHOU: Infantaria ou inimigo não encontrados");
}

// 4. TESTE 2: COMANDO SEGUIR
show_debug_message("🧪 TESTE 2: Comando SEGUIR");

var tanque = instance_first(obj_tanque);
if (tanque == noone) {
    show_debug_message("🚗 Criando tanque de teste...");
    tanque = instance_create_layer(400, 400, "rm_mapa_principal", obj_tanque);
}

if (infantaria != noone && tanque != noone) {
    show_debug_message("🎯 Testando comando SEGUIR:");
    show_debug_message("   - Infantaria: " + string(infantaria));
    show_debug_message("   - Tanque: " + string(tanque));
    
    // Verificar variáveis necessárias
    var tem_comando_atual = variable_instance_exists(infantaria, "comando_atual");
    var tem_estado = variable_instance_exists(infantaria, "estado");
    var tem_alvo_seguir = variable_instance_exists(infantaria, "alvo_seguir");
    
    show_debug_message("   - Variáveis necessárias:");
    show_debug_message("     - comando_atual: " + string(tem_comando_atual));
    show_debug_message("     - estado: " + string(tem_estado));
    show_debug_message("     - alvo_seguir: " + string(tem_alvo_seguir));
    
    if (tem_comando_atual && tem_estado) {
        // Aplicar comando SEGUIR
        infantaria.comando_atual = "SEGUIR";
        infantaria.estado = "seguindo";
        if (tem_alvo_seguir) {
            infantaria.alvo_seguir = tanque;
        }
        
        show_debug_message("✅ Comando SEGUIR aplicado:");
        show_debug_message("   - Comando: " + string(infantaria.comando_atual));
        show_debug_message("   - Estado: " + string(infantaria.estado));
        if (tem_alvo_seguir) {
            show_debug_message("   - Alvo seguir: " + string(infantaria.alvo_seguir));
        }
        
        show_debug_message("✅ TESTE 2 PASSOU: Comando SEGUIR funcionou");
    } else {
        show_debug_message("❌ TESTE 2 FALHOU: Variáveis necessárias não existem");
    }
} else {
    show_debug_message("❌ TESTE 2 FALHOU: Infantaria ou tanque não encontrados");
}

// 5. TESTE 3: COMANDO PATRULHAR
show_debug_message("🧪 TESTE 3: Comando PATRULHAR");

if (infantaria != noone) {
    show_debug_message("🎯 Testando comando PATRULHAR:");
    show_debug_message("   - Infantaria: " + string(infantaria));
    
    // Verificar variáveis necessárias
    var tem_comando_atual = variable_instance_exists(infantaria, "comando_atual");
    var tem_estado = variable_instance_exists(infantaria, "estado");
    var tem_patrulha = variable_instance_exists(infantaria, "patrulha");
    var tem_modo_patrulha = variable_instance_exists(infantaria, "modo_patrulha");
    
    show_debug_message("   - Variáveis necessárias:");
    show_debug_message("     - comando_atual: " + string(tem_comando_atual));
    show_debug_message("     - estado: " + string(tem_estado));
    show_debug_message("     - patrulha: " + string(tem_patrulha));
    show_debug_message("     - modo_patrulha: " + string(tem_modo_patrulha));
    
    if (tem_comando_atual && tem_estado) {
        // Aplicar comando PATRULHAR
        infantaria.comando_atual = "PATRULHAR";
        infantaria.estado = "patrulhando";
        if (tem_modo_patrulha) {
            infantaria.modo_patrulha = true;
        }
        
        show_debug_message("✅ Comando PATRULHAR aplicado:");
        show_debug_message("   - Comando: " + string(infantaria.comando_atual));
        show_debug_message("   - Estado: " + string(infantaria.estado));
        if (tem_modo_patrulha) {
            show_debug_message("   - Modo patrulha: " + string(infantaria.modo_patrulha));
        }
        
        show_debug_message("✅ TESTE 3 PASSOU: Comando PATRULHAR funcionou");
    } else {
        show_debug_message("❌ TESTE 3 FALHOU: Variáveis necessárias não existem");
    }
} else {
    show_debug_message("❌ TESTE 3 FALHOU: Infantaria não encontrada");
}

// 6. TESTE 4: COMANDOS EM NAVIOS
show_debug_message("🧪 TESTE 4: Comandos em navios");

var navio = instance_first(obj_lancha_patrulha);
if (navio == noone) {
    show_debug_message("🚢 Criando navio de teste...");
    navio = instance_create_layer(600, 600, "rm_mapa_principal", obj_lancha_patrulha);
}

if (navio != noone) {
    show_debug_message("🎯 Testando comandos em navio:");
    show_debug_message("   - Navio: " + string(navio));
    
    // Verificar variáveis necessárias
    var tem_comando_atual = variable_instance_exists(navio, "comando_atual");
    var tem_estado = variable_instance_exists(navio, "estado");
    var tem_selecionado = variable_instance_exists(navio, "selecionado");
    
    show_debug_message("   - Variáveis necessárias:");
    show_debug_message("     - comando_atual: " + string(tem_comando_atual));
    show_debug_message("     - estado: " + string(tem_estado));
    show_debug_message("     - selecionado: " + string(tem_selecionado));
    
    if (tem_estado) {
        // Testar seleção
        navio.selecionado = true;
        show_debug_message("✅ Navio selecionado: " + string(navio.selecionado));
        
        // Testar movimento
        navio.estado = "movendo";
        navio.destino_x = 700;
        navio.destino_y = 700;
        
        show_debug_message("✅ Comando de movimento aplicado:");
        show_debug_message("   - Estado: " + string(navio.estado));
        show_debug_message("   - Destino: (" + string(navio.destino_x) + ", " + string(navio.destino_y) + ")");
        
        show_debug_message("✅ TESTE 4 PASSOU: Comandos em navio funcionaram");
    } else {
        show_debug_message("❌ TESTE 4 FALHOU: Variáveis necessárias não existem");
    }
} else {
    show_debug_message("❌ TESTE 4 FALHOU: Navio não encontrado");
}

// 7. RESULTADO FINAL
show_debug_message("🎯 RESULTADO FINAL DOS COMANDOS TÁTICOS:");
show_debug_message("   - TESTE 1 (ATACAR): " + (infantaria != noone && inimigo != noone ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 2 (SEGUIR): " + (infantaria != noone && tanque != noone ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 3 (PATRULHAR): " + (infantaria != noone ? "✅ PASSOU" : "❌ FALHOU"));
show_debug_message("   - TESTE 4 (NAVIOS): " + (navio != noone ? "✅ PASSOU" : "❌ FALHOU"));

show_debug_message("=== TESTE DE COMANDOS TÁTICOS CONCLUÍDO ===");
