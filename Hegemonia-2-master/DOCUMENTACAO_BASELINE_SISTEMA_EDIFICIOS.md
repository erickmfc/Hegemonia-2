# 📋 DOCUMENTAÇÃO - COMPORTAMENTO ESPERADO DO SISTEMA DE EDIFÍCIOS

## 🎯 **COMPORTAMENTO ATUAL (BASELINE)**

### **✅ SISTEMA IMPLEMENTADO:**
- **Script unificado:** `scr_edificio_clique_unificado()` criado
- **Eventos Mouse_53:** Todos os edifícios atualizados para usar sistema unificado
- **Conflito removido:** `obj_controlador_unidades/Mouse_53.gml` deletado
- **Ferramentas de teste:** Scripts de diagnóstico criados

### **🏢 EDIFÍCIOS CONFIGURADOS:**
1. **obj_quartel** → Abre `obj_menu_recrutamento`
2. **obj_quartel_marinha** → Abre `obj_menu_recrutamento_marinha`
3. **obj_aeroporto_militar** → Abre `obj_menu_recrutamento_aereo`
4. **obj_casa** → Mostra informações básicas
5. **obj_banco** → Mostra informações básicas
6. **obj_research_center** → Abre menu de pesquisa

### **🔄 FLUXO ESPERADO:**
1. **Clique em edifício** → `scr_edificio_clique_unificado()` executa
2. **Desseleção automática** → Todas as unidades são desselecionadas
3. **Detecção de clique** → Múltiplos métodos de verificação
4. **Lógica específica** → Cada edifício executa sua funcionalidade
5. **Menu abre** → Interface apropriada é exibida

### **🧪 COMANDOS DE TESTE:**
- **F1:** Diagnóstico completo (`scr_diagnostico_edificios_completo()`)
- **F2:** Teste de menus (`scr_teste_menus_edificios()`)
- **F3:** Teste de coordenadas

### **✅ RESULTADOS ESPERADOS:**
- ✅ Cliques em edifícios funcionam sem conflitos
- ✅ Unidades são desselecionadas automaticamente
- ✅ Menus abrem corretamente
- ✅ Coordenadas funcionam com zoom
- ✅ Sistema unificado e consistente

## 📊 **STATUS ATUAL:**
- **Fase 1:** ✅ CONCLUÍDA
- **Próxima:** Fase 2 - Implementação
- **Tempo estimado:** 10 minutos
