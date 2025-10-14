// =========================================================
// EVENTO DE PRODUÇÃO DE RECURSOS
// Este código roda toda vez que um ciclo de produção termina.
// =========================================================

// Usamos uma estrutura 'switch' para adicionar o recurso ao estoque global correto.
// Isso torna o sistema expansível para futuros tipos de recursos.
switch (tipo_recurso) {
    case "dinheiro":
        global.dinheiro += producao_por_ciclo;
        // Atualizar também o mapa consolidado
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Dinheiro"] += producao_por_ciclo;
        }
        break;
        
    case "minerio":
        global.minerio += producao_por_ciclo;
        // Atualizar também o mapa consolidado
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Minério"] += producao_por_ciclo;
        }
        break;
    
    case "petroleo":
        global.petroleo += producao_por_ciclo;
        // Atualizar também o mapa consolidado
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Petróleo"] += producao_por_ciclo;
        }
        break;
        
    case "populacao":
        global.populacao += producao_por_ciclo;
        // Atualizar também o mapa consolidado
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "População"] += producao_por_ciclo;
        }
        break;
        
    // Recursos avançados do Tesouro da Nação
    case "ouro":
        global.ouro += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Ouro"] += producao_por_ciclo;
        }
        break;
        
    case "aluminio":
        global.aluminio += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Alumínio"] += producao_por_ciclo;
        }
        break;
        
    case "cobre":
        global.cobre += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Cobre"] += producao_por_ciclo;
        }
        break;
        
    case "titanio":
        global.titanio += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Titânio"] += producao_por_ciclo;
        }
        break;
        
    case "uranio":
        global.uranio += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Urânio"] += producao_por_ciclo;
        }
        break;
        
    case "litio":
        global.litio += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Lítio"] += producao_por_ciclo;
        }
        break;
        
    case "borracha":
        global.borracha += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Borracha"] += producao_por_ciclo;
        }
        break;
        
    case "silicio":
        global.silicio += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Silício"] += producao_por_ciclo;
        }
        break;
        
    case "madeira":
        global.madeira += producao_por_ciclo;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            global.estoque_recursos[? "Madeira"] += producao_por_ciclo;
        }
        break;
        
    default:
        show_debug_message("AVISO: Tipo de recurso não reconhecido: " + string(tipo_recurso));
        break;
}

show_debug_message("Produzido: " + string(producao_por_ciclo) + " de " + tipo_recurso);

// Reinicia o alarme para o próximo ciclo de produção.
// Isso cria o loop de produção contínua.
var _ciclo_de_producao = 600; // Mesma duração definida no evento Create
alarm[0] = _ciclo_de_producao;